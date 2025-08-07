# frozen_string_literal: true

require "rails_helper"

RSpec.describe EventAttendee do
  let(:event_attendee) { create :event_attendee }

  it { expect(event_attendee).to be_valid }

  it "schedules an email" do
    expect(event_attendee.reload.email_scheduled_on).not_to be_nil
  end

  context "with past event" do
    let(:event_attendee) { create :event_attendee, event: }
    let(:event) { create :event, :past_event }

    it "does not schedule email" do
      expect(event_attendee.reload.email_scheduled_on).to be_nil
    end

    it "will not email about event" do
      expect(event_attendee.reload.email_delivered_at).to eq EventAttendee::NEVER_DELIVER
    end
  end

  describe ".friends_attending" do
    subject { described_class.friends_attending(event:, profile:) }

    let(:profile) { create :profile }
    let(:event) { create :event }

    it "returns nothing with no events" do
      expect(subject.count).to eq 0
    end

    context "when attending events" do
      let!(:event_attendee) { create :event_attendee, event:, profile: }

      it { expect(subject.count).to eq 0 }

      context "with friends attending" do
        let(:friendship) { create :friendship, buddy: profile, status: :accepted }
        let!(:friend_attendee) { create :event_attendee, event:, profile: friendship.friend }

        it { expect(subject).to include(friend_attendee) }
      end
    end
  end

  describe ".for_email" do
    # if existing event_attendee (email_scheduled_on and email_delivered_at is null)
    # if future event (email_scheduled_on is set, email_delivered_at is null)
    # if distant future event (same as above)
    # if past event (email_scheduled_on is null and email_delivered_at is epoch)
  end

  describe "#schedule_email" do
    subject { event_attendee.schedule_email }

    it "sets email_scheduled_on" do
      subject
      expect(event_attendee.email_scheduled_on).to eq (event_attendee.event.start_at - 1.week).to_date
    end

    context "when attending past event" do
      let(:event) { create :event, :past_event }
      let(:event_attendee) { create :event_attendee, event: }

      it "does not schedule email" do
        subject
        expect(event_attendee.email_scheduled_on).to be_nil
      end

      # Set email_delivered_at to a past datetime, so it's not included in the partial index
      it "sets email_delivered_at to unix epoch" do
        subject
        expect(event_attendee.email_delivered_at).to eq Time.at(0).in_time_zone
      end

      context "when email has already been delivered" do
        let(:event_attendee) { create :event_attendee, event:, email_delivered_at: }
        let(:email_delivered_at) { 1.week.ago.to_date }

        it "keep email_delivered_at" do
          subject
          expect(event_attendee.email_delivered_at).to eq email_delivered_at
        end
      end
    end

    context "when email is already scheduled" do
      let(:event_attendee) { build :event_attendee, email_scheduled_on: }
      let(:email_scheduled_on) { 2.weeks.from_now.to_date }

      it "leaves the email_scheduled_at" do
        subject
        expect(event_attendee.email_scheduled_on).to eq email_scheduled_on
      end
    end

    context "when event_attendee is invalid and there is no event" do
      let(:event_attendee) { build :event_attendee, event: nil }

      it "doesn't set a date" do
        subject
        expect(event_attendee.email_scheduled_on).to be_nil
      end
    end
  end
end

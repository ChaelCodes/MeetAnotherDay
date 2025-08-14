# frozen_string_literal: true

require "rails_helper"

FRIENDS_ATTENDING_TEXT = "Several of your friends are also attending!"
NO_FRIENDS_ATTENDING_TEXT = "Does the event have a Slack or Discord? Try introducing yourself over there!"

RSpec.describe EventAttendeeMailer do
  describe "#pre_event_email" do
    subject(:mail) { described_class.with(event_attendee:).pre_event_email }

    let(:event_attendee) { create :event_attendee, event:, profile: }
    let(:profile) { create :profile, name: "Jane Doe" }
    let(:event) { create :event, name: "RubyConf" }

    it "sends an email", :aggregate_failures do
      expect(mail.subject).to eq "You are attending RubyConf!"
      expect(mail.to).to eq [profile.user.email]
      expect(mail.body).to include "Jane Doe is attending RubyConf!"
      expect(mail.body).to include NO_FRIENDS_ATTENDING_TEXT
    end

    context "with a friend attending" do
      let(:friend) { create :profile, name: "Hercule Poirot", visibility: "everyone" }
      let!(:friend_event_attendee) { create :event_attendee, event:, profile: friend }
      let!(:friendship) { create :friendship, buddy: profile, friend:, status: :accepted }

      it "tells you a friend is attending", :aggregate_failures do
        # binding.irb
        expect(mail.body).to include "Hercule Poirot"
        expect(mail.body).to include FRIENDS_ATTENDING_TEXT
        expect(mail.body).not_to include NO_FRIENDS_ATTENDING_TEXT
      end

      context "with friend hiding visibility" do
        let(:friend) { create :profile, name: "Hercule Poirot", visibility: "myself" }

        it "doesn't reveal event attendance", :aggregate_failures do
          expect(mail.body).not_to include "Hercule Poirot"
          expect(mail.body).not_to include FRIENDS_ATTENDING_TEXT
          expect(mail.body).to include NO_FRIENDS_ATTENDING_TEXT
        end
      end
    end
  end

  describe "#after_deliver" do
    subject(:delivery) { described_class.with(event_attendee:).pre_event_email.deliver_now }

    let(:event_attendee) { create :event_attendee }

    it "updates event_attendee's email_delivered_at" do
      subject
      expect(event_attendee.reload.email_delivered_at).not_to be_nil
    end
  end
end

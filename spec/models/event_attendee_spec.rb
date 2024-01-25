# frozen_string_literal: true

require "rails_helper"

RSpec.describe EventAttendee do
  let(:event_attendee) { create :event_attendee }

  it { expect(event_attendee).to be_valid }

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
end

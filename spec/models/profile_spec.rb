# frozen_string_literal: true

require "rails_helper"

RSpec.describe Profile, type: :model do
  let(:profile) { create :profile }

  describe "#attending?" do
    subject { profile.attending? event }

    let(:event) { create :event }

    it { is_expected.to be_falsey }

    context "when profile is attending" do
      let!(:event_attendee) { create :event_attendee, profile: profile, event: event }

      it { is_expected.to be_truthy }
    end
  end
end

# frozen_string_literal: true

require "rails_helper"

RSpec.describe Profile do
  let(:profile) { create :profile }

  describe "validations" do
    it "has a valid factory" do
      expect(profile).to be_valid
    end

    context "with duplicate handle" do
      let(:duplicate_handle) { build :profile, handle: profile.handle.downcase }

      it "does not allow two profiles to have the same handle" do
        profile
        duplicate_handle.valid?
        expect(duplicate_handle.errors.full_messages).to include("Handle has already been taken")
      end
    end
  end

  describe "#attending?" do
    subject { profile.attending? event }

    let(:event) { create :event }

    it { is_expected.to be_falsey }

    context "when profile is attending" do
      let!(:event_attendee) { create :event_attendee, profile:, event: }

      it { is_expected.to be_truthy }
    end
  end
end

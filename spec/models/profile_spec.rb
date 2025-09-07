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

    context "with duplicate user" do
      let(:duplicate_user_profile) { build :profile, user: profile.user }

      it "does not allow two profiles for the same user" do
        profile
        duplicate_user_profile.valid?
        expect(duplicate_user_profile.errors.full_messages).to include("User has already been taken")
      end

      it "prevents saving a second profile for the same user" do
        profile
        duplicate_user_profile = build :profile, user: profile.user, handle: "different_handle"
        expect { duplicate_user_profile.save! }.to raise_error(ActiveRecord::RecordInvalid,
                                                               /User has already been taken/)
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

  describe "#befriended" do
    subject { described_class.befriended(profile) }

    context "with 'authenticated' visibility friend" do
      let(:authenticated_profile) { create :profile, :authenticated }
      let!(:friendship) { create :friendship, buddy: authenticated_profile, friend: profile, status: :accepted }

      it "does include" do
        expect(subject).to include authenticated_profile
      end
    end

    context "with 'friends' visibility friend" do
      let(:friends_profile) { create :profile, :friends }
      let!(:friendship) { create :friendship, buddy: friends_profile, friend: profile, status: :accepted }

      it "does include" do
        expect(subject).to include friends_profile
      end
    end

    context "with 'myself' visibility friend" do
      let(:myself_profile) { create :profile, :myself }
      let!(:friendship) { create :friendship, buddy: myself_profile, friend: profile, status: :accepted }

      it "does not include" do
        expect(subject).not_to include myself_profile
      end
    end
  end
end

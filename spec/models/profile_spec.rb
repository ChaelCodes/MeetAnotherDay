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

  describe "#friends" do
    subject { profile.friends }

    it { is_expected.to be_empty }

    context "when profile has friends" do
      let(:friend) { create :profile }
      let!(:friendship) { Friendship.create(friend: friend, buddy: profile, status: :accepted) }

      it { is_expected.to include(friend) }
    end

    context "when profile has buddies" do
      let(:buddy) { create :profile }
      let!(:friendship) { Friendship.create(friend: profile, buddy: buddy, status: :accepted) }

      it { is_expected.to include(buddy) }
    end

    context "when profile has requested friends" do
      let(:friend) { create :profile }
      let!(:friendship) { Friendship.create(friend: friend, buddy: profile, status: :requested) }

      it "does not include friend requests" do
        is_expected.not_to include(friend)
      end
    end

    context "when profile has pending friend requests" do
      let(:buddy) { create :profile }
      let!(:friendship2) { Friendship.create(friend: profile, buddy: buddy, status: :requested) }

      it { is_expected.not_to include(buddy) }
    end
  end

  describe "#friendship_with" do
    subject { profile.friendship_with(friend) }

    let(:friend) { create :profile }

    it { is_expected.to be_nil }

    context "when profile is the buddy" do
      let!(:friendship) { create :friendship, buddy: profile, friend: friend }

      it { is_expected.to eq friendship }
    end

    context "when the profile is the friend" do
      let!(:friendship) { create :friendship, buddy: friend, friend: profile }

      it { is_expected.to eq friendship }
    end
  end
end

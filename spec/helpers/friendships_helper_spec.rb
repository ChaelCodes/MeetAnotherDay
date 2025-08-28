# frozen_string_literal: true

require "rails_helper"

# Describes the FriendshipHelper
RSpec.describe FriendshipsHelper do
  describe "#accept_friendship_button" do
    subject { accept_friendship_button(friendship, current_profile) }

    let(:current_user) { create :user }
    let(:current_profile) { create :profile, user: current_user }

    context "when no one wants to be your friend" do
      let(:friendship) { build :friendship, status: :requested, buddy: current_profile }

      it { is_expected.to be_nil }
    end

    context "when you have requested friendship" do
      let(:friendship) { create :friendship, friend: current_profile, status: :requested }

      it { is_expected.to be_nil }
    end

    context "when they are friendly with you" do
      let!(:friendship) { create :friendship, buddy: current_profile, status: :accepted }

      it { is_expected.to be_nil }
    end

    context "when your friendship is requested" do
      let!(:friendship) { create :friendship, buddy: current_profile, status: :requested }

      it "allows you to accept Friend Request" do
        is_expected.to match(/Accept friend request/)
      end

      context "when they are already friends with you" do
        let!(:their_friendship) { create :friendship, friend: current_profile, status: :accepted }

        it "allows you to accept Friend Request" do
          is_expected.to match(/Accept friend request/)
        end
      end
    end
  end

  describe "#befriend_button" do
    subject { befriend_button(friendship, current_profile) }

    let(:current_user) { create :user }
    let(:current_profile) { create :profile, user: current_user }

    context "when you are already friendly" do
      let(:friendship) { create :friendship, buddy: current_profile, status: :accepted }

      it { is_expected.to be_nil }
    end

    context "when you're not friendly yet" do
      let(:friendship) { build :friendship, buddy: current_profile, status: :accepted }

      it { is_expected.to match(/Befriend/) }
    end

    context "when you're the friend, not the buddy" do
      let(:friendship) { create :friendship, friend: current_profile, status: :accepted }

      it { is_expected.to be_nil }
    end
  end

  describe "#block_button" do
    subject { block_button(friendship, current_profile) }

    let(:current_user) { create :user }
    let(:current_profile) { create :profile, user: current_user }

    context "with existing friendship" do
      let(:friendship) { create :friendship, buddy: current_profile }

      it { is_expected.to match(/Block/) }
    end

    context "with no friendship" do
      let(:friendship) { build :friendship, buddy: current_profile }

      it { is_expected.to match(/Block/) }
    end

    context "when you have blocked them" do
      let(:friendship) { create :friendship, buddy: current_profile, status: :blocked }

      it { is_expected.to be_nil }
    end

    context "when it's not your friendship" do
      let(:friendship) { create :friendship, friend: current_profile }

      it { is_expected.to be_nil }
    end
  end

  describe "#cancel_friendship_button" do
    subject { cancel_friendship_button(relationship) }

    let(:profile) { create :profile }
    let(:other_profile) { create :profile }
    let(:relationship) { Relationship.new(profile:, other_profile:) }

    context "when friend request sent" do
      let!(:friendship) { create :friendship, status: :accepted, buddy: profile, friend: other_profile }
      let!(:other_friendship) { create :friendship, status: :requested, buddy: other_profile, friend: profile }

      it { is_expected.to match(/Cancel friend request/) }
    end

    context "when friend request received" do
      let!(:friendship) { create :friendship, status: :requested, buddy: profile, friend: other_profile }
      let!(:other_friendship) { create :friendship, status: :accepted, buddy: other_profile, friend: profile }

      it { is_expected.not_to match(/Cancel friend request/) }
    end
  end

  describe "#destroy_friendship_button" do
    subject { destroy_friendship_button(relationship) }

    let(:relationship) { Relationship.new(profile:, other_profile:) }
    let(:profile) { create :profile }
    let(:other_profile) { create :profile }

    context "when friendship isn't saved" do
      it { is_expected.to be_nil }
    end

    context "when friendship is accepted" do
      let!(:friendship) { create :friendship, buddy: profile, friend: other_profile, status: :accepted }

      it { is_expected.to match(/Unfriend/) }
    end

    context "when friendship is blocked" do
      let!(:friendship) { create :friendship, buddy: profile, friend: other_profile, status: :blocked }

      it { is_expected.to match(/Unblock/) }
    end

    context "when friendship is requested" do
      let!(:friendship) { create :friendship, buddy: profile, friend: other_profile, status: :requested }

      it { is_expected.to match(/Ignore/) }
    end

    context "when friend request has been sent" do
      let!(:friendship) { create :friendship, buddy: profile, friend: other_profile, status: :accepted }
      let!(:other_friendship) { create :friendship, buddy: other_profile, friend: profile, status: :requested }

      it { is_expected.to be_nil }
    end
  end

  describe "#request_friend_button" do
    subject { request_friend_button(relationship) }

    let(:relationship) { Relationship.new(profile:, other_profile:) }
    let(:profile) { create :profile }
    let(:other_profile) { create :profile }

    it { is_expected.to be_nil }

    context "when you are already friends" do
      let!(:friendship) { create :friendship, status: :accepted, buddy: profile, friend: other_profile }
      let!(:other_friendship) { create :friendship, status: :accepted, buddy: other_profile, friend: profile }

      it { is_expected.to be_nil }
    end

    context "when there is a friend request" do
      let!(:friendship) { create :friendship, status: :accepted, buddy: profile, friend: other_profile }
      let!(:other_friendship) { create :friendship, status: :requested, buddy: other_profile, friend: profile }

      it { is_expected.to be_nil }
    end

    context "when you are friendly" do
      let!(:friendship) { create :friendship, status: :accepted, buddy: profile, friend: other_profile }

      it { is_expected.to match(/Request Friend/) }
    end

    context "when you blocked them" do
      let!(:friendship) { create :friendship, status: :blocked, buddy: profile, friend: other_profile }

      it { is_expected.to be_nil }
    end
  end

  describe "#relationship_buttons" do
    subject { relationship_buttons(relationship) }

    let(:profile) { create :profile }
    let(:other_profile) { create :profile }
    let(:relationship) { Relationship.new(profile:, other_profile:) }

    context "when no relationship", :aggregate_failures do
      it { is_expected.to match(/Befriend/) }
      it { is_expected.not_to match(/Request Friend/) }
      it { is_expected.not_to match(/Cancel friend request/) }
      it { is_expected.not_to match(/Accept friend request/) }
      it { is_expected.not_to match(/Unfriend/) }
      it { is_expected.to match(/Block/) }
    end

    context "when friends", :aggregate_failures do
      let!(:friendship) { create :friendship, buddy: profile, friend: other_profile, status: :accepted }
      let!(:other_friendship) { create :friendship, buddy: other_profile, friend: profile, status: :accepted }

      it { is_expected.not_to match(/Befriend/) }
      it { is_expected.not_to match(/Request Friend/) }
      it { is_expected.not_to match(/Cancel friend request/) }
      it { is_expected.not_to match(/Accept friend request/) }
      it { is_expected.to match(/Unfriend/) }
      it { is_expected.to match(/Block/) }
    end

    context "when you have sent a friend request" do
      let!(:friendship) { create :friendship, buddy: profile, friend: other_profile, status: :accepted }
      let!(:other_friendship) { create :friendship, buddy: other_profile, friend: profile, status: :requested }

      it { is_expected.not_to match(/Befriend/) }
      it { is_expected.not_to match(/Request Friend/) }
      it { is_expected.not_to match(/Unfriend/) }
      it { is_expected.to match(/Cancel friend request/) }
      it { is_expected.not_to match(/Accept friend request/) }
      it { is_expected.to match(/Block/) }
    end

    context "when you are friendly" do
      let!(:friendship) { create :friendship, buddy: profile, friend: other_profile, status: :accepted }

      it { is_expected.not_to match(/Befriend/) }
      it { is_expected.to match(/Request Friend/) }
      it { is_expected.to match(/Unfriend/) }
      it { is_expected.not_to match(/Cancel friend request/) }
      it { is_expected.not_to match(/Accept friend request/) }
      it { is_expected.to match(/Block/) }
    end

    context "when you have received a friend request" do
      let!(:friendship) { create :friendship, buddy: profile, friend: other_profile, status: :requested }

      it { is_expected.not_to match(/Befriend/) }
      it { is_expected.not_to match(/Request Friend/) }
      it { is_expected.not_to match(/Unfriend/) }
      it { is_expected.not_to match(/Cancel friend request/) }
      it { is_expected.to match(/Accept friend request/) }
      it { is_expected.to match(/Ignore/) }
      it { is_expected.to match(/Block/) }
    end

    context "when they have blocked you" do
      let!(:friendship) { create :friendship, buddy: other_profile, friend: profile, status: :blocked }

      it { is_expected.to match(/Befriend/) }
      it { is_expected.not_to match(/Request Friend/) }
      it { is_expected.not_to match(/Unfriend/) }
      it { is_expected.not_to match(/Cancel friend request/) }
      it { is_expected.not_to match(/Accept friend request/) }
      it { is_expected.not_to match(/Ignore/) }
      it { is_expected.to match(/Block/) }

      context "when you are friendly" do
        let!(:your_friendship) { create :friendship, buddy: profile, friend: other_profile, status: :accepted }

        it { is_expected.not_to match(/Befriend/) }
        it { is_expected.not_to match(/Request Friend/) }
        it { is_expected.to match(/Unfriend/) }
        it { is_expected.not_to match(/Cancel friend request/) }
        it { is_expected.not_to match(/Accept friend request/) }
        it { is_expected.not_to match(/Ignore/) }
        it { is_expected.to match(/Block/) }
      end
    end

    context "when you have blocked them" do
      let!(:friendship) { create :friendship, buddy: profile, friend: other_profile, status: :blocked }

      it { is_expected.not_to match(/Befriend/) }
      it { is_expected.not_to match(/Request Friend/) }
      it { is_expected.not_to match(/Unfriend/) }
      it { is_expected.not_to match(/Cancel friend request/) }
      it { is_expected.not_to match(/Accept friend request/) }
      it { is_expected.not_to match(/Ignore/) }
      it { is_expected.not_to match(/Block/) }
      it { is_expected.to match(/Unblock/) }
    end
  end
end

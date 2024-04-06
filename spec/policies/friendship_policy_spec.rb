# frozen_string_literal: true

require "rails_helper"

describe FriendshipPolicy, type: :policy do
  permissions :show? do
    let(:friendship) { create :friendship }

    context "with no User" do
      let(:user) { nil }

      it { expect(described_class).not_to permit(user, friendship) }
    end

    context "with random confirmed user" do
      let(:profile) { create :profile }
      let(:user) { profile.user }

      it { expect(described_class).not_to permit(user, friendship) }
    end

    context "with friendship's buddy" do
      let(:user) { friendship.buddy.user }

      it { expect(described_class).to permit(user, friendship) }
    end

    context "with friendship's friend" do
      let(:user) { friendship.friend.user }

      it { expect(described_class).to permit(user, friendship) }

      context "when the buddy has blocked friend" do
        let(:friendship) { create :friendship, status: :blocked }

        it { expect(described_class).not_to permit(user, friendship) }
      end
    end
  end

  permissions ".scope?" do
    subject { Pundit.policy_scope(user, Friendship.all) }

    let(:user) { profile.user }
    let(:profile) { create :profile }
    let!(:friendship) { create :friendship }

    context "when logged out" do
      let(:user) { nil }

      it "does not display any friendships" do
        is_expected.to be_empty
      end
    end

    context "without a profile" do
      let(:user) { create :user }

      it "does not display any friendships" do
        is_expected.to be_empty
      end
    end

    context "when you have a friend" do
      let!(:friendship) { create :friendship, buddy: profile }

      it "returns your friendships" do
        is_expected.to contain_exactly(friendship)
      end
    end

    context "when other profile has friended user" do
      let!(:friendship) { create :friendship, friend: profile, status: :accepted }

      it "shows you that people like you" do
        is_expected.to contain_exactly(friendship)
      end
    end

    context "when user has requested friendship" do
      let!(:friendship) { create :friendship, friend: profile, status: :requested }

      it "shows you the friend request" do
        is_expected.to contain_exactly(friendship)
      end
    end

    context "when other profile has blocked user" do
      let!(:friendship) { create :friendship, friend: profile, status: :blocked }

      it "doesn't show you that people don't like you" do
        is_expected.to be_empty
      end
    end

    context "when the user is not involved with the friendship" do
      let!(:friendship) { create :friendship }

      it "does not display any friendships" do
        is_expected.to be_empty
      end
    end
  end
end

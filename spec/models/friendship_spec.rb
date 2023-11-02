# frozen_string_literal: true

require "rails_helper"

RSpec.describe Friendship do
  let(:friendship) { create :friendship }

  it { expect(friendship).to be_valid }

  describe "#create_notification" do
    subject { friendship } # create_notification is called in an after_create callback

    let(:notification) { Notification.find_by(notifiable: friendship) }

    it "creates a new notification" do
      expect { subject }.to change(Notification, :count).by(1)
    end

    it "creates a notificattion for the friend request" do
      friendship # Creates Friendship and Notification
      expect(notification).to have_attributes(
        {
          message: "Chael wants to be friends with Chael!",
          profile: friendship.friend
        }
      )
    end
  end

  describe "#not_my_profile" do
    subject { friendship.not_my_profile(profile) }

    let!(:profile) { create :profile }

    context "when I am the buddy" do
      let!(:friend) { create :profile }
      let(:friendship) { create :friendship, buddy: profile, friend: }

      it { is_expected.to eq(friend) }
    end

    context "when I am the friend" do
      let!(:buddy) { create :profile }
      let!(:friendship) { create :friendship, buddy:, friend: profile }

      it { is_expected.to eq(buddy) }
    end

    context "when I am the third wheel" do
      it { is_expected.to be_nil }
    end
  end

  describe "#to_s" do
    subject { friendship.to_s }

    let(:buddy) { create :profile, name: "Xavier" }
    let(:friend) { create :profile, name: "Mr.Flibble" }

    context "with accepted friendship" do
      let(:friendship) { create :friendship, :accepted, buddy:, friend: }

      it { is_expected.to eq "Xavier and Mr.Flibble are friends!" }
    end

    context "with blocked friendship" do
      let(:friendship) { create :friendship, :blocked, buddy:, friend: }

      it { is_expected.to eq "Xavier and Mr.Flibble are NOT friends." }
    end

    context "with requested friendship" do
      let(:friendship) { create :friendship, :requested, buddy:, friend: }

      it { is_expected.to eq "Xavier wants to be friends with Mr.Flibble!" }
    end
  end
end

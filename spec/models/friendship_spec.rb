# frozen_string_literal: true

require "rails_helper"

RSpec.describe Friendship do
  let(:friendship) { create :friendship }

  it { expect(friendship).to be_valid }

  context "when buddy and friend are the same" do
    let(:friendship) { build :friendship, buddy: profile, friend: profile }
    let(:profile) { create :profile }

    it { expect(friendship).not_to be_valid }
  end

  describe "#manage_notification" do
    context "when friendship is created as accepted" do
      let!(:friendship) { create :friendship, :accepted }

      it "does not create a notification" do
        expect(Notification.find_by(notifiable: friendship)).to be_nil
      end
    end

    context "when friendship is created as blocked" do
      let!(:friendship) { create :friendship, :blocked }

      it "does not create a notification" do
        expect(Notification.find_by(notifiable: friendship)).to be_nil
      end
    end

    context "when creating a friendship request" do
      let!(:friendship) { create :friendship, :requested }
      let(:notification) { Notification.find_by(notifiable: friendship) }

      it "creates a notification" do
        expect(notification).to have_attributes(
          {
            message: "Chael wants to be friends with Chael!",
            profile: friendship.buddy
          }
        )
      end
    end

    context "when friendship status changes from requested to accepted" do
      let!(:friendship) { create :friendship, :requested }

      it "removes the notification" do
        expect { friendship.update(status: :accepted) }.to change(Notification, :count).by(-1)
      end
    end

    context "when friendship status changes from requested to blocked" do
      let!(:friendship) { create :friendship, :requested }

      it "removes the notification" do
        expect { friendship.update(status: :blocked) }.to change(Notification, :count).by(-1)
      end
    end

    context "when friendship is destroyed" do
      let!(:friendship) { create :friendship, :requested }

      it "removes the notification" do
        expect { friendship.destroy }.to change(Notification, :count).by(-1)
      end
    end
  end

  describe "#to_s" do
    subject { friendship.to_s }

    let(:buddy) { create :profile, name: "Xavier" }
    let(:friend) { create :profile, name: "Chael" }

    context "with accepted friendship" do
      let(:friendship) { create :friendship, :accepted, buddy:, friend: }

      it { is_expected.to eq "Xavier feels friendly towards Chael!" }
    end

    context "with blocked friendship" do
      let(:friendship) { create :friendship, :blocked, buddy:, friend: }

      it { is_expected.to eq "Xavier has blocked Chael." }
    end

    context "with requested friendship" do
      let(:friendship) { create :friendship, :requested, buddy:, friend: }

      it { is_expected.to eq "Chael wants to be friends with Xavier!" }
    end
  end
end

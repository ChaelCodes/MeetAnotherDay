# frozen_string_literal: true

require "rails_helper"

RSpec.describe Notification do
  let(:notification) { create :notification }

  it { expect(notification).to be_valid }

  it "factory only creates one notification",
     skip: "I suspect this is a concurrency issue - see factory for notes" do
    notification
    expect(described_class.count).to eq 1
  end

  context "with abuse report" do
    let(:notification) { create :notification, :report_abuse }

    it { expect(notification).to be_valid }
  end

  describe ".from_friendship" do
    subject { described_class.from_friendship friendship }

    let(:buddy) { create :profile }
    let(:friend) { create :profile }
    let(:friendship) { create :friendship, buddy:, friend:, status: }

    before(:each) do
      # Ensure no pre-existing notifications
      friendship.notifications.destroy_all
    end

    context "when friendship is requested" do
      let(:status) { :requested }

      it "creates a notification" do
        expect { subject }.to change(described_class, :count).by(1)
      end

      it "creates notification with correct attributes" do
        expect(subject).to have_attributes(
          profile: buddy,
          message: friendship.to_s,
          url: "http://www.example.com/friendships/#{friendship.id}"
        )
      end

      it "does not create duplicate notifications" do
        described_class.from_friendship(friendship)
        expect { described_class.from_friendship(friendship) }.not_to change(described_class, :count)
      end
    end

    context "when friendship is accepted" do
      let(:status) { :accepted }
      let!(:existing_notification) { create :notification, notifiable: friendship, profile: buddy }

      it "deletes existing notification" do
        expect { described_class.from_friendship(friendship) }.to change(described_class, :count).by(-1)
      end

      it "does not error when no notification exists" do
        existing_notification.destroy
        expect { described_class.from_friendship(friendship) }.not_to change(described_class, :count)
      end
    end

    context "when friendship is blocked" do
      let(:status) { :blocked }
      let!(:existing_notification) { create :notification, notifiable: friendship, profile: buddy }

      it "deletes existing notification" do
        expect { described_class.from_friendship(friendship) }.to change(described_class, :count).by(-1)
      end
    end

    context "when friendship is not persisted" do
      let(:friendship) { build :friendship, :requested, buddy:, friend: }

      it "does not create a notification" do
        expect { subject }.not_to change(described_class, :count)
      end
    end

    context "when friendship is nil" do
      let(:status) { :requested }

      it "does not error" do
        expect { described_class.from_friendship(nil) }.not_to raise_error
      end
    end
  end
end

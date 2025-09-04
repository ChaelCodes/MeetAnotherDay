# frozen_string_literal: true

require "rails_helper"

RSpec.describe Relationship do
  describe "#initialize" do
    let!(:profile) { create :profile }
    let!(:other_profile) { create :profile }
    let!(:friendship) { create :friendship, buddy: profile, friend: other_profile }
    let!(:other_friendship) { create :friendship, buddy: other_profile, friend: profile }

    context "when initialized with profiles" do
      let(:relationship) { described_class.new(profile:, other_profile:) }

      it "sets all attributes", :aggregate_failures do
        expect(relationship.friendship).to eq friendship
        expect(relationship.other_friendship).to eq other_friendship
        expect(relationship.profile).to eq profile
        expect(relationship.other_profile).to eq other_profile
      end
    end

    context "when initialized with friendship" do
      let(:relationship) { described_class.new(friendship:) }

      it "sets all attributes", :aggregate_failures do
        expect(relationship.friendship).to eq friendship
        expect(relationship.profile).to eq profile
        expect(relationship.other_profile).to eq other_profile
        expect(relationship.other_friendship).to eq other_friendship
      end
    end

    context "when initialized with other_friendship" do
      let(:relationship) { described_class.new(other_friendship:) }

      it "sets all attributes", :aggregate_failures do
        expect(relationship.friendship).to eq friendship
        expect(relationship.profile).to eq profile
        expect(relationship.other_profile).to eq other_profile
        expect(relationship.other_friendship).to eq other_friendship
      end
    end

    context "when just profile is set" do
      let(:relationship) { described_class.new(profile:) }

      it "raises error" do
        expect { relationship }.to raise_error ActiveModel::ValidationError
      end
    end

    context "when just other_profile is set" do
      let(:relationship) { described_class.new(other_profile:) }

      it "raises error" do
        expect { relationship }.to raise_error ActiveModel::ValidationError
      end
    end
  end

  describe "#description" do
    subject { described_class.new(friendship:).description }

    let(:profile) { create :profile }

    context "when you are are both friendly" do
      let(:friendship) { create :friendship, buddy: profile, status: :accepted }
      let!(:other_friendship) { create :friendship, buddy: friendship.friend, friend: profile, status: :accepted }

      it { is_expected.to eq "You are friends with #{friendship.friend.name}." }
    end

    context "when you are friendly" do
      let(:friendship) { create :friendship, buddy: profile, status: :accepted }

      it { is_expected.to eq "You are friendly with #{friendship.friend.name}." }
    end

    context "when you are friendly, but they blocked you" do
      let(:friendship) { create :friendship, buddy: profile, status: :accepted }
      let!(:other_friendship) { create :friendship, buddy: friendship.friend, friend: profile, status: :blocked }

      it { is_expected.to eq "You are friendly with #{friendship.friend.name}." }
    end

    context "when you have blocked them" do
      let(:friendship) { create :friendship, buddy: profile, status: :blocked }

      it { is_expected.to eq "You have blocked #{friendship.friend.name}." }
    end

    context "when you are friendly, and want them to be" do
      let(:friendship) { create :friendship, buddy: profile, status: :accepted }
      let!(:other_friendship) { create :friendship, buddy: friendship.friend, friend: profile, status: :requested }

      it { is_expected.to eq "You have sent a friend request to #{friendship.friend.name}." }
    end

    context "when they are friendly with you" do
      let(:friendship) { create :friendship, buddy: profile, status: :requested }
      let!(:other_friendship) { create :friendship, buddy: friendship.friend, friend: profile, status: :accepted }

      it { is_expected.to eq "#{friendship.friend.name} sent you a friend request." }
    end

    context "when no friendships" do
      let(:friendship) { build :friendship, buddy: profile, status: :requested }

      it { is_expected.to eq "You have no relationship." }
    end
  end

  describe "#request_sent?" do
    subject { relationship.request_sent? }

    let(:profile) { create :profile }
    let(:other_profile) { create :profile }
    let(:relationship) { described_class.new(profile:, other_profile:) }

    it { is_expected.to be_falsey }

    context "when friend request has been sent" do
      let!(:friendship) { create :friendship, status: :accepted, buddy: profile, friend: other_profile }
      let!(:other_friendship) { create :friendship, status: :requested, buddy: other_profile, friend: profile }

      it { is_expected.to be_truthy }
    end

    context "when friend request has been received" do
      let!(:friendship) { create :friendship, status: :requested, buddy: profile, friend: other_profile }
      let!(:other_friendship) { create :friendship, status: :accepted, buddy: other_profile, friend: profile }

      it { is_expected.to be_falsey }
    end
  end

  describe "#request_received?" do
    subject { relationship.request_received? }

    let(:profile) { create :profile }
    let(:other_profile) { create :profile }
    let(:relationship) { described_class.new(profile:, other_profile:) }

    it { is_expected.to be_falsey }

    context "when friend request has been sent" do
      let!(:friendship) { create :friendship, status: :accepted, buddy: profile, friend: other_profile }
      let!(:other_friendship) { create :friendship, status: :requested, buddy: other_profile, friend: profile }

      it { is_expected.to be_falsey }
    end

    context "when friend request has been received" do
      let!(:friendship) { create :friendship, status: :requested, buddy: profile, friend: other_profile }
      let!(:other_friendship) { create :friendship, status: :accepted, buddy: other_profile, friend: profile }

      it { is_expected.to be_truthy }
    end
  end
end

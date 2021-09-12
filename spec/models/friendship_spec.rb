# frozen_string_literal: true

require "rails_helper"

RSpec.describe Friendship, type: :model do
  let(:friendship) { create(:friendship) }

  it { expect(friendship).to be_valid }

  describe "#not_my_profile" do
    subject { friendship.not_my_profile(profile) }

    let!(:profile) { create(:profile) }

    context "when I am the buddy" do
      let!(:friend) { create(:profile) }
      let(:friendship) { create(:friendship, buddy: profile, friend: friend) }

      it { is_expected.to eq(friend) }
    end

    context "when I am the friend" do
      let!(:buddy) { create(:profile) }
      let!(:friendship) { create(:friendship, buddy: buddy, friend: profile) }

      it { is_expected.to eq(buddy) }
    end

    context "when I am the third wheel" do
      it { is_expected.to be_nil }
    end
  end
end

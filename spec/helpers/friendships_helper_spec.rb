# frozen_string_literal: true

require "rails_helper"

# Describes the FriendshipHelper
RSpec.describe FriendshipsHelper, type: :helper do
  describe "#friendship_button" do
    subject { helper.friendship_button(profile, my_profile) }

    let(:profile) { create(:profile) }
    let(:my_profile) { create(:profile) }

    it "returns a button" do
      is_expected.to match(/Request Friend/)
    end

    context "when the profiles are friends" do
      let!(:friendship) { create(:friendship, buddy: profile, friend: my_profile, status: :accepted) }

      it "says they friends" do
        is_expected.to match(%r{friendships/#{friendship.id}})
      end
    end

    context "when the friendship has been blocked" do
      let!(:friendship) { create(:friendship, buddy: profile, friend: my_profile, status: :blocked) }

      it "says they are not friends" do
        is_expected.to match(/Request Declined/)
      end
    end
  end
end

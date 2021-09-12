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
        is_expected.to match(/Friends/)
        is_expected.to match(/friendships\/#{friendship.id}/)
      end
    end

    context "the friendship has been declined" do
      let!(:friendship) { create(:friendship, buddy: profile, friend: my_profile, status: :declined) }

      it "says they are not friends" do
        is_expected.to match(/Request Declined/)
      end
    end

    context "when they ignored the request" do
      let!(:friendship) { create(:friendship, buddy: my_profile, friend: profile, status: :ignored) }

      it "does not tell them you ignored" do
        is_expected.to match(/Request Sent/)
      end
    end

    context "when I ignored the request" do
      let!(:friendship) { create(:friendship, buddy: profile, friend: my_profile, status: :ignored) }

      it "lets you change your mind" do
        is_expected.to match(/Be my buddy?/)
      end
    end
  end
end

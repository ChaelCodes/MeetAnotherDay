# frozen_string_literal: true

require "rails_helper"

describe "Friendships" do
  let!(:friendship) { create(:friendship) }
  let(:user) { nil }
  let(:path) { friendships_path }

  before(:each) do
    sign_in user if user
    visit path
  end

  it_behaves_like "unauthenticated user does not have access"

  context "when user logged in" do
    let(:user) { create :user }

    it "reminds the user to make a profile" do
      expect(page).to have_link "Make a Profile", href: new_profile_path
    end

    context "when user has a profile" do
      let(:profile) { create :profile, user: user }
      let(:friendship) { create :friendship, buddy: profile }

      it "shows the user's friends" do
        expect(page).to have_link friendship.friend.name, href: profile_path(friendship.friend)
      end
    end
  end
end

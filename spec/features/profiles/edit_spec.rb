# frozen_string_literal: true

require "rails_helper"

describe "Profile" do
  let(:profile) { create :profile }

  include_examples "unauthenticated user does not have access" do
    let(:path) { "/profiles/#{profile.id}/edit" }
  end

  context "with logged in user" do
    let(:user) { profile.user }

    before(:each) do
      sign_in user
      visit(+"/profiles/#{profile.id}/edit")
    end

    it "can update profile" do
      expect(page).to have_content "Editing Profile"
      fill_in "profile[handle]", with: "ChaelChats"
      click_button "Update Profile"
      profile.reload
      expect(page).to have_content("Profile was successfully updated.")
      expect(profile.handle).to eq("ChaelChats")
    end
  end
end

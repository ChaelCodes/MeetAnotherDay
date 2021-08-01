# frozen_string_literal: true

require "rails_helper"

describe "Profile" do
  include_examples "unauthenticated user does not have access" do
    let(:path) { "/profiles/new".dup }
  end

  context "when user logged in" do
    let(:user) { create :user }

    before(:each) do
      sign_in user
      visit "/profiles/new".dup
      fill_in "profile[name]", with: "Chael"
      fill_in "profile[handle]", with: "ChaelCodes"
    end

    it "allows users to create profiles" do
      expect(page).to have_content "New Profile"
      click_button "Create Profile"
      profile = Profile.last
      expect(page).to have_content "Profile was successfully created."
      expect(profile).to have_attributes({
                                           name: "Chael",
                                           bio: "",
                                           handle: "ChaelCodes",
                                           user_id: user.id
                                         })
    end
  end
end

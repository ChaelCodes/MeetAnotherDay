# frozen_string_literal: true

require "rails_helper"

describe "Profile#new" do
  include_examples "unauthenticated user does not have access" do
    let(:path) { "/profiles/new".dup }
  end

  context "logged in user" do
    let(:user) { create :user }

    before(:each) do
      sign_in user
      visit "/profiles/new".dup
    end

    it "allows users to create profiles" do
      expect(page).to have_content "New Profile"
      fill_in "profile[name]", with: "Chael"
      fill_in "profile[handle]", with: "ChaelCodes"
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

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
      visit("/profiles/#{profile.id}/edit")
    end

    it "can update profile" do
      expect(page).to have_content "Editing Profile"
      fill_in "profile[handle]", with: "ChaelChats"
      click_button "Update Profile"
      profile.reload
      expect(page).to have_content("Profile was successfully updated.")
      expect(profile.handle).to eq("ChaelChats")
    end

    it "navigates to show page when clicking Show" do
      expect(page).to have_link "Show", href: profile_path(profile)
      click_link "Show"
      expect(page).to have_current_path(profile_path(profile))
      expect(page).to have_content profile.name
    end

    it "navigates to profiles index when clicking All Profiles" do
      expect(page).to have_link "All Profiles", href: profiles_path
      click_link "All Profiles"
      expect(page).to have_current_path(profiles_path)
      expect(page).to have_content "Profiles"
    end
  end

  context "when user is admin" do
    let(:user) { create :user, :admin }

    it "allows user to destroy profile" do
      # Do not allow admin to edit profiles
      expect(page).to have_no_link "Edit", href: edit_profile_path(profile)
      expect(page).to have_content "Danger Zone"
      expect(page).to have_button "Delete"
      click_button "Delete"
      expect(page).to have_content("Profile was successfully destroyed.")
    end
  end
end

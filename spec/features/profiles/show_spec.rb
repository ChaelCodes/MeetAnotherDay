# frozen_string_literal: true

require "rails_helper"

describe "Profile" do
  let(:profile) { create :profile }
  let(:user) { nil }

  before(:each) do
    sign_in user if user
    visit("/profiles/#{profile.id}")
  end

  it "does not permit access" do
    expect(page).to have_content("You are not authorized to perform this action.")
  end

  context "when user logged in" do
    let(:user) { create :user }

    it "shows the profile" do
      expect(page).to have_content "ChaelCodes"
      expect(page).to have_no_link "Edit", href: edit_profile_path(profile)
      expect(page).to have_no_button "Delete"
      expect(page).to have_css ".qr-code-container"
    end

    context "when user has a profile" do
      let(:current_profile) { create :profile }
      let(:user) { current_profile.user }

      it "allows user to befriend another" do
        expect(page).to have_button "Befriend"
        click_button "Befriend"
        expect(page).to have_content "Friendship was successfully created."
      end
    end

    context "when profile belongs to the user" do
      let(:user) { profile.user }

      it "allows user to edit profile" do
        expect(page).to have_link "Edit", href: edit_profile_path(profile)
        expect(page).to have_no_button "Delete" # Too dangerous, it's on the edit page
      end

      it "navigates to edit page when clicking Edit" do
        expect(page).to have_link "Edit", href: edit_profile_path(profile)
        click_link "Edit"
        expect(page).to have_current_path(edit_profile_path(profile))
        expect(page).to have_content "Editing Profile"
      end

      it "navigates to profiles index when clicking All Profiles" do
        expect(page).to have_link "All Profiles", href: profiles_path
        click_link "All Profiles"
        expect(page).to have_current_path(profiles_path)
        expect(page).to have_content "Profiles"
      end
    end

    context "when profile has markdown in bio" do
      let(:profile) { create :profile, bio: "I have **bold** text and [a link](https://example.com)" }

      it "renders markdown in bio" do
        expect(page).to have_css "strong", text: "bold"
        expect(page).to have_link "a link", href: "https://example.com"
      end
    end
  end
end

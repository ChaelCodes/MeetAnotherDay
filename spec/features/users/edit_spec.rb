# frozen_string_literal: true

require "rails_helper"

describe "Users" do
  let(:user_profile) do
    create(:user)
  end

  before(:each) do
    sign_in user if user
    visit "/users/#{user_profile.id}/edit".dup
  end

  context "when no user logged in" do
    let(:user) { nil }

    it "demands signup" do
      expect(page).to have_content "You need to sign in or sign up before continuing."
      expect(page).not_to have_content user_profile.name
    end
  end

  context "when user logged in does not match" do
    let(:user) { create(:user) }

    it "permission to edit denied" do
      expect(page).to have_content "You are not authorized to perform this action."
    end
  end

  context "when overdue_unconfirmed user logged in does not match" do
    let(:user) { create(:user, :overdue_unconfirmed) }

    it "permission to edit denied" do
      expect(page).to have_content "You are not authorized to perform this action."
    end
  end

  context "when user unconfirmed" do
    let(:user) { create(:user, :unconfirmed) }

    it "prompts the user to confirm email" do
      expect(page).to have_content "You have to confirm your email address before continuing."
      expect(page).not_to have_content user_profile.name
    end
  end

  context "when profile belongs to user" do
    let(:user) { user_profile }

    it "permission to edit denied" do
      expect(page).to have_content "Editing User"
      fill_in "user[name]", with: "ChaelChats"
      click_button "Update User"
      user_profile.reload
      expect(page).to have_content("User was successfully updated.")
      expect(user_profile.name).to eq("ChaelChats")
    end
  end
end

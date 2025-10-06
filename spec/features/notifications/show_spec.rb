# frozen_string_literal: true

require "rails_helper"

describe "Notification" do
  let(:notification) { create :notification }
  let(:user) { nil }

  before(:each) do
    sign_in user if user
    visit("/notifications/#{notification.id}")
  end

  it "does not permit access" do
    expect(page).to have_content("You need to sign in or sign up before continuing.")
  end

  context "when user is the profile owner" do
    let(:user) { notification.profile.user }

    it "shows the notification" do
      expect(page).to have_content notification.message
      expect(page).to have_button "Delete"
    end

    it "navigates to notifications index when clicking All Notifications" do
      expect(page).to have_link "All Notifications", href: notifications_path
      click_link "All Notifications"
      expect(page).to have_current_path(notifications_path)
      expect(page).to have_content "Notifications"
    end

    it "has delete button available for the notification" do
      expect(page).to have_button "Delete"
    end
  end
end
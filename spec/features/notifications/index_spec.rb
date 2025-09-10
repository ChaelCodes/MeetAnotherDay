# frozen_string_literal: true

require "rails_helper"

describe "Notifications" do
  let!(:notification) { create :notification, url: "/friendships" }
  let(:user) { nil }
  let(:path) { notifications_path }

  before(:each) do
    # Currently there is a bug where the factory creates two notifications
    # This is a temporary workaround to delete the spare
    Notification.where.not(message: "You have a new Friend Request!").destroy_all
    sign_in user if user
    visit path
  end

  it_behaves_like "unauthenticated user does not have access"

  context "when user logged in" do
    let(:user) { notification.profile.user }

    it "shows the user's notifications", :aggregate_failures do
      expect(page).to have_content "Notifications"
      expect(page).to have_link notification.message, href: "/friendships"
      click_link notification.message
      expect(page).to have_current_path notification.url, ignore_query: true
    end

    it "deletes a notification" do
      click_button(class: "delete")
      expect { notification.reload }.to raise_error(ActiveRecord::RecordNotFound)
      expect(page).to have_no_link notification.message, href: "/friendships"
      expect(page).to have_content "Notification was successfully destroyed."
    end
  end
end

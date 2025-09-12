# frozen_string_literal: true

require "rails_helper"

describe "New Event" do
  let(:user) { nil }

  before(:each) do
    sign_in user if user
    visit(new_event_path)
  end

  it "does not permit access" do
    expect(page).to have_content("You need to sign in or sign up before continuing.")
  end

  context "when user logged in" do
    let(:user) { create :user }

    it "allows access for confirmed users" do
      expect(page).to have_content "New Event"
      expect(page).to have_field "Name"
      expect(page).to have_field "Description"
      expect(page).to have_button "Submit"
    end

    it "navigates to events index when clicking Cancel" do
      expect(page).to have_link "Cancel", href: events_path
      click_link "Cancel"
      expect(page).to have_current_path(events_path)
      expect(page).to have_content "Events"
    end
  end
end
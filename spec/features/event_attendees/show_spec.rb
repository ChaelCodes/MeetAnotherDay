# frozen_string_literal: true

require "rails_helper"

describe "Event Attendee" do
  let(:event_attendee) { create :event_attendee }
  let(:user) { nil }

  before(:each) do
    sign_in user if user
    visit("/event_attendees/#{event_attendee.id}")
  end

  it "does not permit access" do
    expect(page).to have_content("You are not authorized to perform this action.")
  end

  context "when user is the profile owner" do
    let(:user) { event_attendee.profile.user }

    it "shows the event attendee" do
      expect(page).to have_content event_attendee.profile.name
      expect(page).to have_content event_attendee.event.name
      expect(page).to have_link "Edit", href: edit_event_attendee_path(event_attendee)
      expect(page).to have_button "Delete"
    end

    it "navigates to edit page when clicking Edit" do
      expect(page).to have_link "Edit", href: edit_event_attendee_path(event_attendee)
      click_link "Edit"
      expect(page).to have_current_path(edit_event_attendee_path(event_attendee))
      expect(page).to have_content "Editing Event Attendee"
    end

    it "navigates to event attendees index when clicking All Event Attendees" do
      expect(page).to have_link "All Event Attendees", href: event_attendees_path
      click_link "All Event Attendees"
      expect(page).to have_current_path(event_attendees_path)
      expect(page).to have_content "Event Attendees"
    end

    it "has delete button available for the event attendee" do
      expect(page).to have_button "Delete"
    end
  end
end
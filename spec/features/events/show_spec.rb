# frozen_string_literal: true

require "rails_helper"

describe "Events" do
  let(:event) { create :event }
  let(:user) { nil }

  before(:each) do
    sign_in user if user
    visit("/events/#{event.id}")
  end

  it "shows the event" do
    expect(page).to have_content "RubyConf"
    expect(page).to have_no_link "Edit", href: edit_event_path(event)
    expect(page).to have_no_button "Delete"
    expect(page).to have_link "All Events", href: events_path
    expect(page).to have_css ".qr-code-container"
  end

  it "does not allow you to attend" do
    expect(page).to have_no_button "Attend"
  end

  context "when user without profile" do
    let(:user) { create :user }

    it "shows the event" do
      expect(page).to have_content "RubyConf"
      expect(page).to have_no_link "Edit", href: edit_event_path(event)
      expect(page).to have_no_button "Delete"
      expect(page).to have_no_button "Attend"
    end
  end

  context "when user with profile" do
    let(:profile) { create :profile }
    let(:user) { profile.user }

    it "allows profile to attend" do
      expect(page).to have_no_link "Edit", href: edit_event_path(event)
      expect(page).to have_no_button "Delete"
      expect(page).to have_button "Attend"
      click_button "Attend"
      expect(EventAttendee.find_by(event:, profile:)).to be_present
    end

    it "navigates to event attendees page when clicking All Attendees" do
      click_link "All Attendees"
      expect(page).to have_current_path(event_attendees_path(event_id: event.id))
      expect(page).to have_content "Event Attendees"
    end
  end

  context "when profile is attending" do
    let(:event_attendee) { create :event_attendee, event: }
    let(:profile) { event_attendee.profile }
    let(:user) { profile.user }

    it "shows attending message" do
      expect(page).to have_content "You are attending this event."
      expect(page).to have_link "attending", href: event_attendee_path(event_attendee)
      click_link "attending"
      expect(page).to have_content profile.name
    end

    it "shows cancel attendance button" do
      expect(page).to have_button "Cancel Attendance"
      click_button "Cancel Attendance"
      expect(EventAttendee.find_by(event:, profile:)).not_to be_present
    end
  end

  context "when profile is event organizer" do
    let(:event_attendee) { create :event_attendee, event:, organizer: true }
    let(:profile) { event_attendee.profile }
    let(:user) { profile.user }

    it "shows edit link" do
      expect(page).to have_link "Edit", href: edit_event_path(event)
      expect(page).to have_no_button "Delete"
    end

    it "shows cancel attendance button" do
      expect(page).to have_button "Cancel Attendance"
      click_button "Cancel Attendance"
      expect(EventAttendee.find_by(event:, profile:)).not_to be_present
    end

    it "shows attending message" do
      expect(page).to have_content "You are organizing this event."
      expect(page).to have_link "organizing", href: event_attendee_path(event_attendee)
      click_link "organizing"
      expect(page).to have_content profile.name
    end
  end

  context "when user is admin" do
    let(:user) { create :user, :admin }

    it "allows user to edit and destroy event" do
      expect(page).to have_content "RubyConf"
      expect(page).to have_link "Edit", href: edit_event_path(event)
      expect(page).to have_no_button "Delete"
    end

    it "navigates to edit page when clicking Edit" do
      expect(page).to have_link "Edit", href: edit_event_path(event)
      click_link "Edit"
      expect(page).to have_current_path(edit_event_path(event))
      expect(page).to have_content "Editing #{event.name}"
    end

    it "navigates to events index when clicking All Events" do
      expect(page).to have_link "All Events", href: events_path
      click_link "All Events"
      expect(page).to have_current_path(events_path)
      expect(page).to have_content "Events"
    end
  end
end

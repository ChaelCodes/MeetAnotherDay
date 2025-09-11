# frozen_string_literal: true

require "rails_helper"

describe "Edit Event Attendee" do
  let(:event_attendee) { create :event_attendee }
  let(:user) { nil }

  before(:each) do
    sign_in user if user
    visit(edit_event_attendee_path(event_attendee))
  end

  it "does not permit access" do
    expect(page).to have_content("You need to sign in or sign up before continuing.")
  end

  context "when user logged in" do
    let(:user) { create :user }

    it "does not permit access" do
      expect(page).to have_content("You are not authorized to perform this action.")
    end

    context "when event_attendee is mine" do
      let(:profile) { event_attendee.profile }
      let(:user) { profile.user }

      it "allows user to set their email scheduled on", :aggregate_failures do
        expect(page).to have_content "Editing Event Attendee"
        page.fill_in "Email scheduled on", with: "2025-11-11"
        expect(page).to have_no_checked_field "Organizer"
        click_button "Update Event attendee"
        expect(page).to have_current_path event_attendee_path event_attendee
        expect(page).to have_content("Event attendee was successfully updated.")
        expect(event_attendee.reload.email_scheduled_on).to eq Date.new(2025, 11, 11)
      end
    end

    context "when attendee is organizer" do
      let(:profile) { event_attendee.profile }
      let(:user) { profile.user }
      let(:event_attendee) { create :event_attendee, organizer: true }

      it "allows user to remove themself as organizer", :aggregate_failures do
        expect(page).to have_content "Editing Event Attendee"
        page.fill_in "Email scheduled on", with: "2025-11-11"
        uncheck "Organizer"
        click_button "Update Event attendee"
        expect(page).to have_current_path event_attendee_path event_attendee
        expect(page).to have_content("Event attendee was successfully updated.")
        expect(event_attendee.reload).not_to be_organizer
        expect(event_attendee.email_scheduled_on).to eq Date.new(2025, 11, 11)
      end
    end

    context "when user is admin" do
      let(:user) { create :user, :admin }

      it "allows user to set attendee as organizer", :aggregate_failures do
        expect(page).to have_content "Editing Event Attendee"
        expect(page).to have_no_field "Email scheduled on"
        check "Organizer"
        click_button "Update Event attendee"
        expect(page).to have_current_path event_attendee_path event_attendee
        expect(page).to have_content("Event attendee was successfully updated.")
        expect(event_attendee.reload).to be_organizer
      end
    end
  end
end

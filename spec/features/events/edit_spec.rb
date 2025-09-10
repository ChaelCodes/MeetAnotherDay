# frozen_string_literal: true

require "rails_helper"

describe "Edit Event" do
  let(:event) { create :event }
  let(:user) { nil }

  before(:each) do
    sign_in user if user
    visit(edit_event_path(event))
  end

  it "does not permit access" do
    expect(page).to have_content("You need to sign in or sign up before continuing.")
  end

  context "when user logged in" do
    let(:user) { create :user }

    it "does not permit access" do
      expect(page).to have_content("You are not authorized to perform this action.")
    end

    context "when user is organizer" do
      let(:profile) { event_attendee.profile }
      let(:user) { profile.user }
      let(:event_attendee) { create :event_attendee, event:, organizer: true }

      it "allows user to edit event" do
        expect(page).to have_content "Editing #{event.name}"
        expect(page).to have_field "Name"
        expect(page).to have_field "Description"
        expect(page).to have_button "Submit"
        expect(page).to have_no_button "Delete"
      end
    end

    context "when user is admin" do
      let(:user) { create :user, :admin }

      it "allows user to edit and destroy event" do
        expect(page).to have_content "Editing #{event.name}"
        expect(page).to have_field "Name"
        expect(page).to have_field "Description"
        expect(page).to have_button "Submit"
        expect(page).to have_content "Danger Zone"
        expect(page).to have_button "Delete"
        click_button "Delete"
        expect(page).to have_content("Event was successfully destroyed.")
      end
    end
  end
end

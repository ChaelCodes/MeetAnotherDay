# frozen_string_literal: true

require "rails_helper"

describe "Event Attendees Index" do
  let!(:signed_in_profile) { create(:profile) }
  let!(:visible_event_attendee) { create(:event_attendee, profile: signed_in_profile) }
  let(:user) { nil }

  before(:each) do
    sign_in user if user
    visit(event_attendees_path)
  end

  it "allows public access" do
    expect(page).to have_content "Event Attendees"
  end

  context "when user is signed in" do
    let(:user) { signed_in_profile.user }

    it "shows the event attendees" do
      expect(page).to have_content(visible_event_attendee.profile.name)
      expect(page).to have_content "Event Attendees"
    end

    it "navigates to show page when clicking Show" do
      expect(page).to have_content(visible_event_attendee.profile.name)
      expect(page).to have_link "Show"
      click_link("Show", match: :first)
      expect(page).to have_current_path(event_attendee_path(visible_event_attendee))
    end
  end
end
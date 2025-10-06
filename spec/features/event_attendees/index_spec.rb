# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Event Attendees Index" do
  let(:user) { create :user }
  let(:profile) { create :profile, user: }
  let(:event) { create :event, name: "RubyConf 2024" }
  let!(:event_attendee) { create :event_attendee, event:, profile: }

  before(:each) do
    sign_in user
  end

  describe "when event_id param is provided" do
    it "shows the event name in the title" do
      visit event_attendees_path(event_id: event.id)

      expect(page).to have_content("#{event.name} Attendees")
      expect(page).to have_no_content("Event Attendees")
    end

    it "hides the event column in the table" do
      visit event_attendees_path(event_id: event.id)

      # Should show Profile column header but not Event column header
      expect(page).to have_css("th", text: "Profile")
      within("table thead") do
        expect(page).to have_no_text("Event")
      end

      # Should not show event name in table content
      expect(page).to have_no_css("td", text: event.name)
    end
  end

  describe "when no event_id param is provided" do
    it "shows the default title" do
      visit event_attendees_path

      expect(page).to have_content("Event Attendees")
    end

    it "shows the event column in the table" do
      visit event_attendees_path

      # Should show Event column header
      expect(page).to have_css("th", text: "Event")

      # Should show event name in table content
      expect(page).to have_css("td", text: event.name)
    end
  end
end

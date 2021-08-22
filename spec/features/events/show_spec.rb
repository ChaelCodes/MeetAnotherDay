# frozen_string_literal: true

require "rails_helper"

describe "Events" do
  let(:event) { create(:event) }
  let(:user) { nil }

  before(:each) do
    sign_in user if user
    visit "/events/#{event.id}".dup
  end

  it "shows the event" do
    expect(page).to have_content "RubyConf"
    expect(page).not_to have_link "Edit", href: edit_event_path(event)
    expect(page).not_to have_button "Delete"
    expect(page).to have_link "All Events", href: events_path
  end

  context "when user logged in" do
    let(:user) { create :user }

    it "shows the event" do
      expect(page).to have_content "RubyConf"
      expect(page).not_to have_link "Edit", href: edit_event_path(event)
      expect(page).not_to have_button "Delete"
    end

    context "when user is admin" do
      let(:user) { create :user, :admin }

      it "allows user to edit and destroy event" do
        expect(page).to have_content "RubyConf"
        expect(page).to have_link "Edit", href: edit_event_path(event)
        expect(page).to have_button "Delete"
      end
    end
  end
end

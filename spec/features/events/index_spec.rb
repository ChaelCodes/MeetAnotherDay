# frozen_string_literal: true

require "rails_helper"

describe "Events" do
  let!(:event) { create :event, :ongoing_event, name: "RubyConf" }
  let(:user) { nil }

  before(:each) do
    sign_in user if user
    visit "/events/".dup
  end

  it "shows the event" do
    expect(page).to have_link "RubyConf", href: event_path(event)
    expect(page).not_to have_link "New Event", href: new_event_path
    expect(page).not_to have_link "Edit", href: edit_event_path(event)
    expect(page).not_to have_button "Delete"
  end

  it "only shows future events" do
    past_event = create :event, :past_event
    expect(page).not_to have_link past_event.name, href: event_path(past_event)
  end

  context "when user logged in but unconfirmed email" do
    let(:user) { create :user, confirmed_at: nil, confirmation_sent_at: 1.day.ago }

    it "shows the event" do
      expect(page).to have_link "RubyConf", href: event_path(event)
      expect(page).not_to have_link "New Event", href: new_event_path
      expect(page).not_to have_link "Edit", href: edit_event_path(event)
      expect(page).not_to have_button "Delete"
    end
  end

  context "when user logged in" do
    let(:user) { create :user }

    it "shows the event" do
      expect(page).to have_link "RubyConf", href: event_path(event)
      expect(page).to have_link "New Event", href: new_event_path
      expect(page).not_to have_link "Edit", href: edit_event_path(event)
      expect(page).not_to have_button "Delete"
    end

    context "when user is admin" do
      let(:user) { create :user, :admin }

      it "allows user to edit and destroy event" do
        expect(page).to have_link "RubyConf", href: event_path(event)
        expect(page).to have_link "New Event", href: new_event_path
        expect(page).to have_link "Edit", href: edit_event_path(event)
        expect(page).to have_button "Delete"
      end
    end
  end
end

# frozen_string_literal: true

require "rails_helper"

describe "Page Navigation" do
  let(:admin_user) { create(:user, :admin) }
  let(:user_with_profile) { create(:profile).user }
  let(:event) { create(:event) }
  let(:profile) { create(:profile) }
  let(:event_attendee) { create(:event_attendee, event: event, profile: profile) }
  let(:notification) { create(:notification, profile: profile) }

  describe "Events navigation" do
    context "Event show page" do
      before do
        sign_in admin_user
        visit event_path(event)
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

    context "Event edit page" do
      before do
        sign_in admin_user
        visit edit_event_path(event)
      end

      it "navigates to show page when clicking Show" do
        expect(page).to have_link "Show", href: event_path(event)
        click_link "Show"
        expect(page).to have_current_path(event_path(event))
        expect(page).to have_content event.name
      end

      it "navigates to events index when clicking All Events" do
        expect(page).to have_link "All Events", href: events_path
        click_link "All Events"
        expect(page).to have_current_path(events_path)
        expect(page).to have_content "Events"
      end
    end

    context "Event new page" do
      before do
        sign_in admin_user
        visit new_event_path
      end

      it "navigates to events index when clicking Cancel" do
        expect(page).to have_link "Cancel", href: events_path
        click_link "Cancel"
        expect(page).to have_current_path(events_path)
        expect(page).to have_content "Events"
      end
    end
  end

  describe "Profiles navigation" do
    context "Profile show page as owner" do
      before do
        sign_in profile.user
        visit profile_path(profile)
      end

      it "navigates to edit page when clicking Edit" do
        expect(page).to have_link "Edit", href: edit_profile_path(profile)
        click_link "Edit"
        expect(page).to have_current_path(edit_profile_path(profile))
        expect(page).to have_content "Editing Profile"
      end

      it "navigates to profiles index when clicking All Profiles" do
        expect(page).to have_link "All Profiles", href: profiles_path
        click_link "All Profiles"
        expect(page).to have_current_path(profiles_path)
        expect(page).to have_content "Profiles"
      end
    end

    context "Profile edit page" do
      before do
        sign_in profile.user
        visit edit_profile_path(profile)
      end

      it "navigates to show page when clicking Show" do
        expect(page).to have_link "Show", href: profile_path(profile)
        click_link "Show"
        expect(page).to have_current_path(profile_path(profile))
        expect(page).to have_content profile.name
      end

      it "navigates to profiles index when clicking All Profiles" do
        expect(page).to have_link "All Profiles", href: profiles_path
        click_link "All Profiles"
        expect(page).to have_current_path(profiles_path)
        expect(page).to have_content "Profiles"
      end
    end

    context "Profile new page" do
      before do
        sign_in create(:user)
        visit new_profile_path
      end

      it "navigates to profiles index when clicking Cancel" do
        expect(page).to have_link "Cancel", href: profiles_path
        click_link "Cancel"
        expect(page).to have_current_path(profiles_path)
        expect(page).to have_content "Profiles"
      end
    end
  end

  describe "Event Attendees navigation" do
    context "Event Attendee show page" do
      before do
        sign_in profile.user
        visit event_attendee_path(event_attendee)
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

    context "Event Attendees index page" do
      let!(:signed_in_profile) { create(:profile) }
      let!(:visible_event_attendee) { create(:event_attendee, profile: signed_in_profile) }
      
      before do
        sign_in signed_in_profile.user
        visit event_attendees_path
      end

      it "navigates to show page when clicking Show" do
        expect(page).to have_content(visible_event_attendee.profile.name)
        expect(page).to have_link "Show"
        click_link("Show", match: :first)
        expect(page).to have_current_path(event_attendee_path(visible_event_attendee))
      end
    end
  end

  describe "Notifications navigation" do
    context "Notification show page" do
      before do
        sign_in profile.user
        visit notification_path(notification)
      end

      it "navigates to notifications index when clicking All Notifications" do
        expect(page).to have_link "All Notifications", href: notifications_path
        click_link "All Notifications"
        expect(page).to have_current_path(notifications_path)
        expect(page).to have_content "Notifications"
      end

      it "has delete button available for the notification" do
        expect(page).to have_button "Delete"
      end
    end
  end
end
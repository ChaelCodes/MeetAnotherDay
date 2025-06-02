# frozen_string_literal: true

require "rails_helper"

describe "Events" do
  let(:event) { create :event }
  let(:user) { nil }

  before(:each) do
    sign_in user if user
    visit event_path(event)
  end

  it "shows the event" do
    expect(page).to have_content "RubyConf"
    expect(page).not_to have_link "Edit", href: edit_event_path(event)
    expect(page).not_to have_button "Delete"
    expect(page).not_to have_button "Attend"
    expect(page).to have_link "All Events", href: events_path
  end

  describe "location display" do
    context "when event is online" do
      let(:event) { create :event, location_type: "online" }

      it "shows online indicator" do
        expect(page).to have_content("Online")
        expect(page).not_to have_css("#map")
      end
    end

    context "when event is physical" do
      let(:event) { create :event, :physical, address: "123 Main St" }

      it "shows location details" do
        expect(page).to have_content(event.address)
        expect(page).to have_css("#map")
      end
    end
  end

  context "when user logged in" do
    let(:user) { create :user }
    let(:profile) { create :profile, user: }
    let(:event) { create :event }

    before(:each) do
      profile
      sign_in user
      visit event_path(event)
    end

    context "when not attending" do
      it "shows 'attend' button" do
        expect(page).to have_content "RubyConf"
        expect(page).not_to have_link "Edit", href: edit_event_path(event)
        expect(page).not_to have_button "Delete"
        expect(page).to have_button "Attend"
      end
    end

    context "when already attending" do
      let!(:event_attendee) { create :event_attendee, event:, profile: }

      before(:each) do
        visit event_path(event)
      end

      it "shows 'Not attending' button" do
        expect(profile.reload.attending?(event)).to be true
        expect(page).to have_button("Not Attending")
      end
    end

    context "when user is admin" do
      let(:user) { create :user, :admin }

      it "allows user to edit and destroy event" do
        expect(page).to have_content "RubyConf"
        expect(page).to have_link "Edit", href: edit_event_path(event)
        expect(page).to have_button "Delete"
      end
    end

    context "when user has friends attending" do
      let(:friend) { create :profile }
      let!(:friendship) { create :friendship, buddy: profile, friend:, status: :accepted }
      let!(:event_attendee) { create :event_attendee, event:, profile: friend }

      before(:each) do
        visit event_path(event)
      end

      it "shows friends attending" do
        expect(page).to have_content("1 buddy")
        expect(page).to have_link(friend.to_s)
      end
    end
  end
end

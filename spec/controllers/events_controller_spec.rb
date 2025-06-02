require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  describe "GET #show" do
    let(:event) { create(:event) }
    
    context "when user is not logged in" do
      before { get :show, params: { id: event.id } }

      it "returns successful response" do
        expect(response).to be_successful
      end

      it "does not assign event_attendees" do
        expect(assigns(:event_attendees)).to be_nil
      end

      it "does not assign friends_attending_count" do
        expect(assigns(:friends_attending_count)).to be_nil
      end
    end

    context "when user is logged in" do
      let(:user) { create(:user) }
      let(:profile) { create(:profile, user: user) }
      let!(:friendship) { create(:friendship, buddy: profile, status: :accepted) }
      let!(:event_attendee) { create(:event_attendee, event: event, profile: friendship.friend) }

      before do
        sign_in user
        get :show, params: { id: event.id }
      end

      it "returns successful response" do
        expect(response).to be_successful
      end

      it "assigns event_attendees" do
        expect(assigns(:event_attendees)).to include(event_attendee)
      end

      it "assigns friends_attending_count" do
        expect(assigns(:friends_attending_count)).to eq(1)
      end

      it "assigns current_profile" do
        expect(assigns(:current_profile)).to eq(profile)
      end
    end

    context "when accessing by handle" do
      before { get :show, params: { id: event.handle } }

      it "finds the event by handle" do
        expect(assigns(:event)).to eq(event)
      end
    end

    context "when event has physical location" do
      let(:event) { create(:event, :physical) }
      
      before { get :show, params: { id: event.id } }

      it "shows location details" do
        expect(assigns(:event).physical?).to be true
        expect(assigns(:event).address).to be_present
      end
    end

    context "when event is online" do
      let(:event) { create(:event, location_type: "online") }
      
      before { get :show, params: { id: event.id } }

      it "shows online status" do
        expect(assigns(:event).online?).to be true
        expect(assigns(:event).address).to be_nil
      end
    end
  end
end
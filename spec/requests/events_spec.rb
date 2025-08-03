# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/events" do
  let(:user) { nil }

  before(:each) do
    sign_in user if user
  end

  describe "GET /index" do
    subject { get events_url, params: params.merge(format: :json) }

    let(:params) { {} }

    context "with no events" do
      it "renders a successful response" do
        subject
        expect(json_body["events"]).to be_empty
      end
    end

    context "with events" do
      let!(:past_event) { create :event, :past_event }
      let!(:past_event2) { create :event, :past_event }
      let!(:future_event) { create :event }

      it "renders a list of only future events", :aggregate_failures do
        subject
        events = json_body["events"]
        event_handles = events.pluck "handle"
        expect(events.count).to eq 1
        expect(event_handles).to include future_event.handle
        expect(event_handles).not_to include past_event.handle
      end

      context "with 10+ events" do
        let!(:events) { create_list :event, 11 }

        it "paginates the list", :aggregate_failures do
          subject
          events = json_body["events"]
          links = json_body["links"]
          expect(events.count).to eq 10
          expect(links["first"]).to eq "http://www.example.com/events?format=json&page%5Bnumber%5D=1"
          expect(links["last"]).to eq "http://www.example.com/events?format=json&page%5Bnumber%5D=2"
          expect(links["prev"]).to be_nil
          expect(links["next"]).to eq "http://www.example.com/events?format=json&page%5Bnumber%5D=2"
        end

        context "when second page" do
          let(:params) { { page: { number: 2 } } }

          it "paginates the list", :aggregate_failures do
            subject
            events = json_body["events"]
            links = json_body["links"]
            expect(events.count).to eq 2
            expect(links["first"]).to eq "http://www.example.com/events?page%5Bnumber%5D=1&format=json"
            expect(links["last"]).to eq "http://www.example.com/events?page%5Bnumber%5D=2&format=json"
            expect(links["prev"]).to eq "http://www.example.com/events?page%5Bnumber%5D=1&format=json"
            expect(links["next"]).to be_nil
          end
        end

        context "when limit is passed", skip: "Limits are not working - I need to ask for help" do
          let(:params) { { page: { size: 5 } } }

          it "paginates in chunks of 5" do
            subject
            events = json_body["events"]
            expect(events.count).to eq 5
          end
        end
      end

      context "with past events parameter" do
        let(:params) { { past: true } }

        it "renders a list of only past events", :aggregate_failures do
          subject
          events = json_body["events"]
          event_handles = events.pluck "handle"
          expect(events.count).to eq 2
          expect(event_handles).to include past_event.handle
          expect(event_handles).not_to include future_event.handle
        end
      end
    end
  end

  describe "GET /show" do
    subject(:get_show) { get event_url(event), params: { format: } }

    let(:event) { create :event, name: "RubyConf 2020" }
    let(:format) { :html }

    context "when description has markdown" do
      it "converts markdown to html" do
        get event_url(event)
        expected_str = '<a href="https://rubyconf.org/">RubyConf 2020</a> will be held in <code>Denver</code>.'
        expect(response.body).to include(expected_str)
      end
    end

    context "when format is html" do
      let(:format) { :html }

      it "renders a successful response" do
        get event_url(event)
        expect(response).to be_successful
      end
    end

    context "when format is json" do
      let(:format) { :json }

      it "shares event details" do
        get_show
        expect(json_body).to include(
          "id" => event.id,
          "name" => event.name
        )
      end

      context "when profile has friend attending" do
        let(:user) { friendship.buddy.user }
        let!(:friendship) { create :friendship, status: :accepted }
        let!(:event_attendee) { create :event_attendee, event:, profile: friendship.friend }

        it "includes friend's name" do
          get_show
          expect(json_body.dig("event_attendees", 0, "profile", "name")).to eq friendship.friend.name
        end
      end

      context "when profile has no friend attending" do
        let(:profile) { create :profile }
        let(:user) { profile.user }
        let!(:event_attendee) { create :event_attendee, event: }

        it "does not include stranger's name" do
          get_show
          expect(json_body.dig("attendees", 0, "name")).to be_nil
        end
      end
    end
  end

  describe "GET /show with handle" do
    subject(:get_show) { get "/events/#{event.handle}" }

    let(:event) { create :event }

    it "renders a successful response" do
      get_show
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    subject(:get_new) { get new_event_url }

    include_examples "redirect to sign in"

    context "when user is logged in" do
      let(:user) { create :user }

      it "renders a successful response" do
        get_new
        expect(response).to be_successful
      end
    end
  end

  describe "GET /edit" do
    subject(:get_edit) { get edit_event_url(event) }

    let(:event) { create :event }

    include_examples "redirect to sign in"

    context "when user is logged in" do
      let(:user) { create :user }

      include_examples "unauthorized access"
    end

    context "when admin" do
      let(:user) { create :user, :admin }

      it "renders a successful response" do
        get_edit
        expect(response).to be_successful
      end
    end
  end

  describe "POST /create" do
    subject(:post_create) { post events_url, params: { event: attributes } }

    let(:attributes) { attributes_for :event }

    include_examples "redirect to sign in"

    context "with logged in user" do
      let(:user) { create :user }
      let!(:profile) { create :profile, user_id: user.id }

      it "creates a new Event" do
        expect { post_create }.to change(Event, :count).by(1)
      end

      it "creates a new organizer EventAttendee" do
        expect { post_create }.to change(EventAttendee, :count).by(1)
      end

      it "redirects to the created event" do
        post_create
        expect(response).to redirect_to(event_url(Event.last))
      end

      context "with invalid parameters" do
        let(:attributes) do
          {
            name: "RubyConf"
          }
        end

        it "does not create a new Event" do
          expect do
            post_create
          end.not_to change(Event, :count)
        end

        it "returns an unprocessable entity code" do
          post_create
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end

  describe "PATCH /update" do
    subject(:patch_update) { patch event_url(event), params: { event: attributes } }

    let(:attributes) { { name: "Strangeloop" } }
    let!(:event) { create :event }

    include_examples "redirect to sign in"

    context "with logged in user" do
      let(:user) { create :user }

      include_examples "unauthorized access"
    end

    context "with admin user" do
      let(:user) { create :user, :admin }

      it "updates the requested event" do
        patch_update
        event.reload
        expect(event.name).to eq "Strangeloop"
      end

      it "redirects to the event" do
        patch_update
        expect(response).to redirect_to(event_url(event))
      end

      context "with invalid parameters" do
        let(:attributes) { { start_at: "LUNCHTIME" } }

        it "returns an unprocessable entity code" do
          patch_update
          event.reload
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      context "with organizer user" do
        let(:user) { create :user }
        let!(:event_attendee) { create :event_attendee, organizer: true }

        it "updates the requested event" do
          patch_update
          event.reload
          expect(event.name).to eq "RubyConf"
        end
      end
    end
  end

  describe "DELETE /destroy" do
    subject(:delete_destroy) { delete event_url(event) }

    let!(:event) { create :event }

    include_examples "redirect to sign in"

    context "with logged in user" do
      let(:user) { create :user }

      include_examples "unauthorized access"
    end

    context "when User is admin" do
      let(:user) { create :user, :admin }

      it "destroys the requested event" do
        expect { delete_destroy }.to change(Event, :count).by(-1)
      end

      it "redirects to the events list" do
        delete_destroy
        expect(response).to redirect_to(events_url)
      end
    end
  end
end

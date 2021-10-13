# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/profiles", type: :request do
  let(:profile) { create :profile }
  let(:json_headers) { { ACCEPT: "application/json" } }

  # Test all routes as an authenticated user
  let(:user) { create :user }

  before(:each) do
    sign_in user
  end

  describe "GET /index" do
    subject(:get_index) { get profiles_url }

    let!(:profile) { create :profile }

    it "renders a successful response" do
      get_index
      expect(response.body).to include(profile.name)
    end
  end

  describe "GET /show" do
    subject(:get_show) { get profile_url(profile), headers: json_headers }

    let!(:event_attendee) { create :event_attendee, profile: profile }

    it "renders a successful response" do
      get_show
      expect(response).to be_successful
    end

    it "send events" do
      get_show
      expect(JSON.parse(response.body)["events"].first["id"]).to eq(event_attendee.event.id)
    end
  end

  describe "GET /new" do
    subject(:get_new) { get new_profile_url }

    it "renders a successful response" do
      get new_profile_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    subject(:get_edit) { get edit_profile_url(profile) }

    it "redirects unauthorized user" do
      get_edit
      expect(response).to redirect_to(root_path)
    end

    context "when user edits their profile" do
      let(:user) { profile.user }

      it "render a successful response" do
        get_edit
        expect(response).to be_successful
      end
    end
  end

  describe "POST /create" do
    subject(:post_create) { post profiles_url, params: { profile: attributes } }

    context "with valid parameters" do
      let(:attributes) do
        {
          handle: "ChaelCodes"
        }
      end

      it "creates a new Profile" do
        expect { post_create }.to change(Profile, :count).by(1)
      end

      it "redirects to the created profile" do
        post_create
        expect(response).to redirect_to(profile_url(Profile.last))
      end
    end

    context "with invalid parameters" do
      let(:attributes) { { handle: "" } }

      it "does not create a new Profile" do
        expect { post_create }.to change(Profile, :count).by(0)
      end

      it "returns an unprocessable entity code" do
        post_create
        expect(response.status).to eq(422)
      end
    end
  end

  describe "PATCH /update" do
    subject(:patch_update) do
      patch profile_url(profile), params: { profile: attributes }
    end

    context "with valid parameters" do
      let(:attributes) do
        { handle: "ChaelChats" }
      end

      it "redirects unauthorized user" do
        patch_update
        expect(response).to redirect_to(root_path)
      end

      context "with the profile's creator" do
        let(:user) { profile.user }

        it "updates the requested profile" do
          patch_update
          profile.reload
          expect(profile.handle).to eq "ChaelChats"
        end

        it "redirects to the profile" do
          patch_update
          profile.reload
          expect(response).to redirect_to(profile_url(profile))
        end
      end

      context "with admin" do
        let(:profile) { create :profile, handle: "Foo" }
        let(:user) { create :user, :admin }

        include_examples "unauthorized access"

        it "does not update the profile" do
          patch_update
          profile.reload
          expect(profile.handle).to eq "Foo"
        end
      end
    end

    context "with invalid parameters" do
      let(:attributes) { { handle: "" } }
      let(:user) { profile.user }

      it "returns an unprocessable entity code" do
        patch_update
        expect(response.status).to eq(422)
      end
    end
  end

  describe "DELETE /destroy" do
    subject(:delete_destroy) { delete profile_url(profile) }

    let!(:profile) { create :profile }

    include_examples "unauthorized access"

    context "with profile's creator" do
      let(:user) { profile.user }

      it "destroys the requested profile" do
        expect { delete_destroy }.to change(Profile, :count).by(-1)
      end

      it "redirects to the profiles list" do
        delete_destroy
        expect(response).to redirect_to(profiles_url)
      end
    end

    context "with an admin" do
      let(:user) { create :user, :admin }

      it "destroys the requested profile" do
        expect { delete_destroy }.to change(Profile, :count).by(-1)
      end

      it "redirects to the profiles list" do
        delete_destroy
        expect(response).to redirect_to(profiles_url)
      end
    end
  end
end

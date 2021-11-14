# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/notifications", type: :request do
  let(:user) { nil }
  # Notification. As you add validations to Notification, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    skip("Add a hash of attributes valid for your model")
  end
  let(:invalid_attributes) do
    skip("Add a hash of attributes invalid for your model")
  end
  let(:json_headers) { { ACCEPT: "application/json" } }

  before(:each) do
    sign_in user if user
  end

  describe "GET /index" do
    subject(:get_index) { get notifications_url, headers: headers }

    it_behaves_like "redirect to sign in"

    context "with logged in user" do
      let(:user) { create :user }
      let(:headers) { json_headers }

      context "without notifications" do
        let!(:notification_list) { create_list(:notification, 2) }

        it "returns 0 records" do
          get_index
          expect(JSON.parse(response.body).length).to be_zero
        end
      end

      context "with notifications" do
        let!(:notification) { create :notification, notified: profile }
        let(:profile) { create :profile, user: user }

        it "returns the notification" do
          get_index
          expect(JSON.parse(response.body).dig(0, "id")).to eq notification.id
        end
      end
    end
  end

  describe "GET /show" do
    subject(:get_show) { get notification_url(notification) }

    let(:notification) { create :notification }

    it_behaves_like "redirect to sign in"

    context "with notified user" do
      let(:user) { notification.notified.user }

      it_behaves_like "renders a successful response"
    end

    context "with any user" do
      let(:user) { create :user }

      it_behaves_like "unauthorized access"
    end

    context "with admin" do
      let(:user) { create :user, :admin }
      let(:notification) { create :notification, :report_abuse }

      it_behaves_like "renders a successful response"
    end
  end

  describe "GET /new" do
    subject(:get_new) { get new_notification_url }

    it_behaves_like "redirect to sign in"

    context "with logged in user" do
      let(:user) { create :user }

      it_behaves_like "renders a successful response"
    end
  end

  describe "GET /edit" do
    subject(:get_edit) { get edit_notification_url(notification) }

    let(:notification) { create :notification }

    it_behaves_like "redirect to sign in"

    context "with admin" do
      let(:user) { create :user, :admin }

      it_behaves_like "unauthorized access"
    end
  end

  describe "POST /create" do
    subject(:post_create) { post notifications_url, params: { notification: attributes } }

    let(:notification) { create :notification }
    let(:user) { create :user }
    let(:attributes) { {} }

    context "without logged in user" do
      let(:user) { nil }

      it_behaves_like "redirect to sign in"
    end

    context "with valid parameters" do
      let!(:attributes) { notification.attributes }

      it "creates a new Notification" do
        expect { post_create }.to change(Notification, :count).by(1)
      end

      it "redirects to the created notification" do
        post_create
        expect(response).to redirect_to(notification_url(Notification.last))
      end
    end

    context "with invalid parameters" do
      let(:attributes) { { message: "I forgot everything else!" } }

      it "does not create a new Notification" do
        expect { post_create }.to change(Notification, :count).by(0)
      end

      it_behaves_like "unprocessable entity"
    end
  end

  describe "PATCH /update" do
    subject(:patch_update) do
      patch notification_url(notification), params: { notification: { message: "Editing not allowed" } }
    end

    let(:notification) { create :notification }

    it_behaves_like "redirect to sign in"

    context "with notified user" do
      let(:user) { notification.notified.user }

      it_behaves_like "unauthorized access"
    end
  end

  describe "DELETE /destroy" do
    subject(:delete_destroy) { delete notification_url(notification) }

    let!(:notification) { create :notification }

    it_behaves_like "redirect to sign in"

    context "with any user" do
      let(:user) { create :user }

      it_behaves_like "unauthorized access"
    end

    context "with the notified user" do
      let(:user) { notification.notified.user }

      it "destroys the requested notification" do
        expect { delete_destroy }.to change(Notification, :count).by(-1)
      end

      it "redirects to the notifications list" do
        delete_destroy
        expect(response).to redirect_to(notifications_url)
      end
    end
  end
end

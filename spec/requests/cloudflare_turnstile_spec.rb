# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Cloudflare Turnstile Error Handling" do
  before do
    # Mock the turnstile validation to always fail
    allow_any_instance_of(ApplicationController).to receive(:cloudflare_turnstile_ok?).and_return(false)
  end

  describe "POST /users (user registration)" do
    subject(:post_create) do
      post user_registration_path, params: {
        user: {
          email: "test@example.com",
          password: "password",
          password_confirmation: "password"
        }
      }
    end

    it "redirects back to registration form" do
      post_create
      expect(response).to redirect_to(new_user_registration_path)
    end

    it "shows cloudflare error message" do
      post_create
      follow_redirect!
      expect(flash[:alert]).to eq "Uh oh! We need you to confirm you're not a bot in the cloudflare challenge."
    end
  end

  describe "POST /users/password (password reset)" do
    subject(:post_create) do
      post user_password_path, params: {
        user: {
          email: "test@example.com"
        }
      }
    end

    it "redirects back to password reset form" do
      post_create
      expect(response).to redirect_to(new_user_password_path)
    end

    it "shows cloudflare error message" do
      post_create
      follow_redirect!
      expect(flash[:alert]).to eq "Uh oh! We need you to confirm you're not a bot in the cloudflare challenge."
    end
  end

  describe "POST /users/confirmation (email confirmation)" do
    subject(:post_create) do
      post user_confirmation_path, params: {
        user: {
          email: "test@example.com"
        }
      }
    end

    it "redirects back to confirmation form" do
      post_create
      expect(response).to redirect_to(new_user_confirmation_path)
    end

    it "shows cloudflare error message" do
      post_create
      follow_redirect!
      expect(flash[:alert]).to eq "Uh oh! We need you to confirm you're not a bot in the cloudflare challenge."
    end
  end
end
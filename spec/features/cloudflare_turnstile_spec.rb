# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Cloudflare Turnstile" do
  before(:each) do
    allow_any_instance_of(ApplicationController).to receive(:cloudflare_turnstile_ok?).and_return(false)
  end

  describe "User Registration Form" do
    it "shows error when cloudflare validation fails" do
      visit new_user_registration_path

      fill_in "Email", with: "test@example.com"
      fill_in "Password", with: "password123"
      fill_in "Password confirmation", with: "password123"
      click_button "Sign up"

      expect(page).to have_current_path(new_user_registration_path)
      expect(page).to have_content("Uh oh! We need you to confirm you're not a bot in the cloudflare challenge.")
    end
  end

  describe "Password Reset Form" do
    it "shows error when cloudflare validation fails" do
      visit new_user_password_path

      fill_in "Email", with: "test@example.com"
      click_button "Send me reset password instructions"

      expect(page).to have_current_path(new_user_password_path)
      expect(page).to have_content("Uh oh! We need you to confirm you're not a bot in the cloudflare challenge.")
    end
  end

  describe "Email Confirmation Form" do
    it "shows error when cloudflare validation fails" do
      visit new_user_confirmation_path

      fill_in "Email", with: "test@example.com"
      click_button "Resend confirmation instructions"

      expect(page).to have_current_path(new_user_confirmation_path)
      expect(page).to have_content("Uh oh! We need you to confirm you're not a bot in the cloudflare challenge.")
    end
  end

  describe "Login Form" do
    let!(:user) { create :user, email: "test@example.com", password: "password123" }

    it "shows error when cloudflare validation fails" do
      visit new_user_session_path

      fill_in "Email", with: "test@example.com"
      fill_in "Password", with: "password123"
      click_button "Log in"

      expect(page).to have_current_path(new_user_session_path)
      expect(page).to have_content("Uh oh! We need you to confirm you're not a bot in the cloudflare challenge.")
    end
  end

  context "when cloudflare validation passes" do
    before(:each) do
      allow_any_instance_of(ApplicationController).to receive(:cloudflare_turnstile_ok?).and_return(true)
    end

    describe "User Registration Form" do
      it "successfully creates user account", :aggregate_failures do
        visit new_user_registration_path

        fill_in "Email", with: "test@example.com"
        fill_in "Password", with: "password123"
        fill_in "Password confirmation", with: "password123"
        click_button "Sign up"

        expect(page).to have_content("Welcome!")
        expect(User.find_by(email: "test@example.com")).not_to be_nil
      end
    end

    describe "Password Reset Form" do
      let!(:user) { create :user, email: "test@example.com" }

      it "successfully sends password reset email" do
        visit new_user_password_path

        fill_in "Email", with: "test@example.com"
        click_button "Send me reset password instructions"

        expect(page).to have_content("You will receive an email with instructions on how to reset your password")
      end
    end
  end
end

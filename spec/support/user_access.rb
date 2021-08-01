# frozen_string_literal: true

RSpec.shared_examples "unauthenticated user does not have access" do
  before(:each) do
    sign_in user if user
    visit path.dup
  end

  context "when no user logged in" do
    let(:user) { nil }

    it "demands signup" do
      expect(page).to have_content "You need to sign in or sign up before continuing."
    end
  end

  context "when user is unconfirmed" do
    let(:user) { create(:user, :unconfirmed) }

    it "prompts the user to confirm email" do
      expect(page).to have_content "You have to confirm your email address before continuing."
    end
  end
end

RSpec.shared_examples "redirect to sign in" do
  it "redirect to sign in" do
    subject
    expect(response).to redirect_to new_user_session_path
  end
end

RSpec.shared_examples "unauthorized access" do
  it "redirect to root" do
    subject
    expect(response).to redirect_to root_path
  end

  it "has an unauthorized message" do
    subject
    expect(flash[:alert]).to eq "You are not authorized to perform this action."
  end
end

# frozen_string_literal: true

require "rails_helper"

describe "Page /profiles" do
  before(:each) do
    sign_in user if user
    visit profiles_path
  end

  include_examples "unauthenticated user does not have access" do
    let(:path) { "/profiles/" }
  end

  context "with logged in user" do
    let(:user) { create :user }

    it "is successful" do
      expect(page).to have_content "Profiles"
    end
  end

  describe "searching profiles" do
    let(:user) { create :user }
    let!(:found_profile) { create :profile, name: "Found Profile", visibility: :everyone }
    let!(:hidden_profile) { create :profile, name: "Hidden Profile", visibility: :friends }

    it "shows only profiles matching search term", :aggregate_failures do
      fill_in "search", with: "Fou"
      click_button "Search"
      expect(page).to have_content "Found Profile"
      expect(page).to have_no_content "Hidden Profile"
    end
  end
end

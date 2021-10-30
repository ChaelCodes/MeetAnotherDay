# frozen_string_literal: true

require "rails_helper"

# #109 - Arbitrarily choose profiles as a base to test against.
RSpec.describe "/profiles", type: :request do
  let(:profile) { create :profile }

  # Test all routes as an authenticated user
  let(:user) { create :user }

  before(:each) do
    sign_in user
  end

  describe "POST /create" do
    subject(:post_create) { post profiles_url, params: { profile: attributes } }

    let(:attributes) { { handle: "" } } # Blank to kick out an error.

    context "with invalid parameters" do
      before(:each) do
        post_create
      end

      it "includes the error class" do
        expect(response.body).to match(/input class="(.*)is-danger(.*)"/)
      end
    end
  end
end

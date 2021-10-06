# frozen_string_literal: true

require "rails_helper"

describe "Support" do
  before(:each) do
    visit "/".dup
  end

  it "shows the " do
    expect(page).to have_content "A Brief History of ConfBuddies:"
  end
end

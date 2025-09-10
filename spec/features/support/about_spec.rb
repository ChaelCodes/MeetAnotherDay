# frozen_string_literal: true

require "rails_helper"

describe "Support" do
  before(:each) do
    visit(+"/")
  end

  it "shows the about page" do
    expect(page).to have_content "It was the first day of Strangeloop, and Chael was having lunch alone."
  end
end

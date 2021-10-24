# frozen_string_literal: true

require "rails_helper"

describe "Support" do
  before(:each) do
    visit "/".dup
  end

  it "shows the " do
<<<<<<< HEAD
<<<<<<< HEAD
    expect(page).to have_content "It was the first day of Strangeloop, and Chael was having lunch alone."
=======
    expect(page).to have_content "A Brief History of ConfBuddies:"
>>>>>>> 0969d65 (Add support controller and about page)
=======
    expect(page).to have_content "It was the first day of Strangeloop, and Chael was having lunch alone."
>>>>>>> 1f00004 (Add overdue_unconfirmed tests)
  end
end

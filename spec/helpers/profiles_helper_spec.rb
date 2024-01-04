# frozen_string_literal: true

require "rails_helper"

RSpec.describe ProfilesHelper do
  describe "#profile_picture" do
    subject { helper.profile_picture(email) }

    let(:email) { " TEST@example.com " }

    it "chomps, lowercases, and hashes the email" do
      is_expected.to eq "https://gravatar.com/avatar/973dfe463ec85785f5f95af5ba3906eedb2d931c24e69824a89ea65dba4e813b?s=80&d=retro&r=pg"
    end
  end
end

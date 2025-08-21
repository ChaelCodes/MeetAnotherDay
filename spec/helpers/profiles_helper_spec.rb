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

  describe "#unauthorized_message" do
    subject { helper.unauthorized_message(profile) }

    let(:profile) { build :profile, visibility: }
    let(:visibility) { :everyone }

    it { is_expected.to eq "" }

    context "when visibility is authorized" do
      let(:visibility) { :authenticated }

      it { is_expected.to eq "You must be logged in, and your email confirmed to view this profile." }
    end

    context "when visibility is friends" do
      let(:visibility) { :friends }

      it { is_expected.to eq "You must be friends to view this profile." }
    end

    context "when visibility is myself" do
      let(:visibility) { :myself }

      it { is_expected.to eq "This profile is not visible to others at this time." }
    end

    context "when blocked is true" do
      subject { helper.unauthorized_message(profile, blocked: true) }

      it { is_expected.to eq "This profile is not visible to others at this time." }
    end
  end
end

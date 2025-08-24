# frozen_string_literal: true

require "rails_helper"

RSpec.describe Notification do
  let(:notification) { create :notification }

  it { expect(notification).to be_valid }

  it "factory only creates one notification",
     skip: "I suspect this is a concurrency issue - see factory for notes" do
    notification
    expect(described_class.count).to eq 1
  end

  context "with abuse report" do
    let(:notification) { create :notification, :report_abuse }

    it { expect(notification).to be_valid }
  end
end

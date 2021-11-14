# frozen_string_literal: true

require "rails_helper"

RSpec.describe Notification, type: :model do
  let(:notification) { create :notification }

  it { expect(notification).to be_valid }

  context "with abuse report" do
    let(:notification) { create :notification, :report_abuse }

    it { expect(notification).to be_valid }
  end
end

# frozen_string_literal: true

require "rails_helper"

RSpec.describe Event, type: :model do
  let(:event) { create :event }

  it { expect(event).to be_valid }

  describe "#ongoing_or_upcoming" do
    subject { described_class.ongoing_or_upcoming }

    let!(:past_event) { create :event, :past_event }
    let!(:upcoming_event) { create :event, start_at: 3.days.from_now, end_at: 5.days.from_now }
    let!(:ongoing_event) { create :event, start_at: 3.days.ago, end_at: 1.day.from_now }

    it { is_expected.to include(upcoming_event) }
    it { is_expected.to include(ongoing_event) }
    it { is_expected.not_to include(past_event) }
  end
end

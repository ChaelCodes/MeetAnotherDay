# frozen_string_literal: true

require "rails_helper"

RSpec.describe Event do
  let(:event) { create :event }

  it { expect(event).to be_valid }

  describe "start_at must be before end_at" do
    context "when start_at is after end_at" do
      let(:event) { build :event, start_at: 1.day.from_now, end_at: Time.zone.now }

      it { expect(event).not_to be_valid }
    end

    context "when start_at is before end_at" do
      let(:event) { build :event, start_at: 1.hour.ago, end_at: Time.zone.now }

      it { expect(event).to be_valid }
    end
  end

  describe "#ongoing_or_upcoming" do
    subject { described_class.ongoing_or_upcoming }

    let!(:past_event) { create :event, :past_event }
    let!(:upcoming_event) { create :event, start_at: 3.days.from_now, end_at: 5.days.from_now }
    let!(:ongoing_event) { create :event, start_at: 3.days.ago, end_at: 1.day.from_now }

    it { is_expected.to include(upcoming_event) }
    it { is_expected.to include(ongoing_event) }
    it { is_expected.not_to include(past_event) }
  end

  describe "#future" do
    subject { described_class.future }

    let!(:past_event) { create :event, :past_event }
    let!(:upcoming_event) { create :event, start_at: 3.days.from_now, end_at: 5.days.from_now }
    let!(:ongoing_event) { create :event, start_at: 3.days.ago, end_at: 1.day.from_now }

    it { is_expected.to include(upcoming_event) }
    it { is_expected.not_to include(ongoing_event) }
    it { is_expected.not_to include(past_event) }
  end

  describe "#ongoing" do
    subject { described_class.ongoing }

    let!(:past_event) { create :event, :past_event }
    let!(:upcoming_event) { create :event, start_at: 3.days.from_now, end_at: 5.days.from_now }
    let!(:ongoing_event) { create :event, start_at: 3.days.ago, end_at: 1.day.from_now }

    it { is_expected.not_to include(upcoming_event) }
    it { is_expected.to include(ongoing_event) }
    it { is_expected.not_to include(past_event) }
  end

  describe "#past" do
    subject { described_class.past }

    let!(:past_event) { create :event, :past_event }
    let!(:upcoming_event) { create :event, start_at: 3.days.from_now, end_at: 5.days.from_now }
    let!(:ongoing_event) { create :event, start_at: 3.days.ago, end_at: 1.day.from_now }

    it { is_expected.not_to include(upcoming_event) }
    it { is_expected.not_to include(ongoing_event) }
    it { is_expected.to include(past_event) }
  end
end

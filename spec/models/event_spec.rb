# frozen_string_literal: true

require "rails_helper"

RSpec.describe Event do
  let(:event) { create :event }

  it { expect(event).to be_valid }

  describe "validations" do
    it { is_expected.to validate_presence_of(:start_at) }
    it { is_expected.to validate_presence_of(:end_at) }
    it { is_expected.to validate_presence_of(:location_type) }

    context "when location_type is physical" do
      before(:each) { allow(subject).to receive(:physical?).and_return(true) }

      it { is_expected.to validate_presence_of(:address) }
    end

    context "when location_type is online" do
      before(:each) { allow(subject).to receive(:physical?).and_return(false) }

      it { is_expected.not_to validate_presence_of(:address) }
    end
  end

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

  describe "location handling" do
    context "when physical event" do
      let(:event) { build :event, location_type: "physical", address: "123 Main St" }

      it "geocodes the address", :vcr do
        event.save
        expect(event.latitude).not_to be_nil
        expect(event.longitude).not_to be_nil
      end

      it { expect(event.physical?).to be true }
      it { expect(event.online?).to be false }
    end

    context "when online event" do
      let(:event) { build :event, location_type: "online", address: nil }

      it "does not geocode" do
        event.save
        expect(event.latitude).to be_nil
        expect(event.longitude).to be_nil
      end

      it { expect(event.physical?).to be false }
      it { expect(event.online?).to be true }
    end

    context "when address changes" do
      let(:event) { create :event, location_type: "physical", address: "123 Main St" }

      before(:each) do
        Geocoder::Lookup::Test.add_stub(
          "456 Other St", [
            {
              "coordinates" => [42.0, -71.0],
              "address" => "456 Other St",
              "state" => "Massachusetts",
              "country" => "United States"
            }
          ]
        )
      end

      it "updates coordinates" do
        expect do
          event.update(address: "456 Other St")
        end.to change(event, :latitude)
      end
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

  describe "#past" do
    subject { described_class.past }

    let!(:past_event) { create :event, :past_event }
    let!(:upcoming_event) { create :event, start_at: 3.days.from_now, end_at: 5.days.from_now }
    let!(:ongoing_event) { create :event, start_at: 3.days.ago, end_at: 1.day.from_now }

    it { is_expected.not_to include(upcoming_event) }
    it { is_expected.not_to include(ongoing_event) }
    it { is_expected.to include(past_event) }
  end

  describe "associations" do
    it { is_expected.to have_many(:event_attendees).dependent(:delete_all) }
    it { is_expected.to have_many(:attendees).through(:event_attendees).source(:profile) }
  end
end

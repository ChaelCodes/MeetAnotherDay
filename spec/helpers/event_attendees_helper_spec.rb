# frozen_string_literal: true

require "rails_helper"

RSpec.describe EventAttendeesHelper do
  describe "#email_delivery_text" do
    subject { email_delivery_text(event_attendee) }

    context "when email is scheduled" do
      let(:event_attendee) { build :event_attendee, email_scheduled_on: Date.new(2025, 9, 13), email_delivered_at: nil }

      it {
        is_expected.to eq "You will receive an email telling you which friends are attending on September 13, 2025."
      }
    end

    context "when email has been delivered" do
      let(:event_attendee) do
        build :event_attendee,
              email_scheduled_on: Date.new(2025, 9, 13),
              email_delivered_at: DateTime.new(2025, 9, 13, 8, 0, 0)
      end

      it { is_expected.to eq "Your email about attendees was delivered at September 13, 2025 08:00." }
    end

    context "when no email scheduled" do
      let(:event_attendee) { build :event_attendee, email_scheduled_on: nil, email_delivered_at: nil }

      it { is_expected.to eq "You do not have an email scheduled for this event." }
    end
  end
end

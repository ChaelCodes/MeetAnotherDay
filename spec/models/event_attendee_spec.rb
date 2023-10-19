# frozen_string_literal: true

require "rails_helper"

RSpec.describe EventAttendee do
  let(:event_attendee) { create :event_attendee }

  it { expect(event_attendee).to be_valid }
end

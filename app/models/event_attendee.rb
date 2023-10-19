# frozen_string_literal: true

# Tracks if a Profile is attending a particular event
class EventAttendee < ApplicationRecord
  belongs_to :profile
  belongs_to :event
end

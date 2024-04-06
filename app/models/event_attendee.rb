# frozen_string_literal: true

# Tracks if a Profile is attending a particular event
class EventAttendee < ApplicationRecord
  belongs_to :profile
  belongs_to :event

  def self.friends_attending(event:, profile:)
    EventAttendee.where(event:, profile_id: profile.friendships.accepted.select(:friend_id)).includes(:profile, :event)
  end
end

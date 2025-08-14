# frozen_string_literal: true

# Tracks if a Profile is attending a particular event
class EventAttendee < ApplicationRecord
  belongs_to :profile
  belongs_to :event

  NEVER_DELIVER = Time.at(0).in_time_zone

  after_initialize :schedule_email

  scope :for_email, lambda {
    where(email_delivered_at: nil)
      .where("email_scheduled_on <= ?", Date.current)
  }

  def self.friends_attending(event:, profile:)
    EventAttendee.where(event:, profile_id: profile.friendships.accepted.select(:friend_id)).includes(:profile, :event)
  end

  def schedule_email
    return unless event
    if event.start_at > Time.zone.now
      self.email_scheduled_on ||= event.start_at - 1.week
    else
      self.email_delivered_at ||= NEVER_DELIVER
    end
  end
end

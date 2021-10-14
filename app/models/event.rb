# frozen_string_literal: true

# Events are events that you can attend.
class Event < ApplicationRecord
  has_many :event_attendees, dependent: :delete_all
  has_many :attendees, through: :event_attendees, source: :profile

  validates :start_at, :end_at, presence: true
  validates :handle, presence: true

  scope :ongoing_or_upcoming, -> { where("end_at >= ?", Time.zone.now) }

  def to_s
    name
  end
end

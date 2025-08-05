# frozen_string_literal: true

# Events are events that you can attend.
class Event < ApplicationRecord
  include ::Handleable

  has_many :event_attendees, dependent: :delete_all
  has_many :attendees, through: :event_attendees, source: :profile

  validates_presence_of :start_at, :end_at
  validates_comparison_of :end_at, greater_than: :start_at

  scope :future, -> { where("start_at > ?", Time.zone.now) }
  scope :ongoing_or_upcoming, -> { where("end_at >= ?", Time.zone.now) }
  scope :ongoing, lambda {
                    where("start_at <= ?", Time.zone.now)
                      .where("end_at >= ?", Time.zone.now)
                  }
  scope :past, -> { where("end_at < ?", Time.zone.now) }

  def to_s
    name
  end
end

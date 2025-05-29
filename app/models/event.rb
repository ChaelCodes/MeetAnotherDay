# frozen_string_literal: true

# Events are events that you can attend.
class Event < ApplicationRecord
  include ::Handleable

  enum location_type: {
    online: "online",
    physical: "physical"
    }

  geocoded_by :address
  after_validation :geocode, if: :should_geocode?

  has_many :event_attendees, dependent: :delete_all
  has_many :attendees, through: :event_attendees, source: :profile

  validates :start_at, :end_at, :location_type, presence: true
  validates :address, presence: true, if: :physical?
  validates :location_type, inclusion: { in: location_types.keys }
  validates_comparison_of :end_at, greater_than: :start_at

  scope :ongoing_or_upcoming, -> { where("end_at >= ?", Time.zone.now) }
  scope :past, -> { where("end_at < ?", Time.zone.now) }

  def to_s
    name
  end

  def physical?
    location_type == "physical"
  end

  def online?
    location_type == "online"
  end

  private

  def should_geocode?
    address.present? && 
    address_changed? && 
    physical?
  end
end

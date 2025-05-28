# frozen_string_literal: true

# Events are events that you can attend.
class Event < ApplicationRecord
  include ::Handleable

  geocoded_by :address
  after_validation :geocode, if: ->(obj) { obj.address.present? && obj.address_changed? }

  has_many :event_attendees, dependent: :delete_all
  has_many :attendees, through: :event_attendees, source: :profile

  validates :start_at, :end_at, :location_type, presence: true
  validates :address, presence: true, if: :physical?
  validates :location_type, inclusion: { in: %w[physical online] }
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

  def short_description(length = 150)
    return "" unless description.present?
    desc = ActionView::Base.full_sanitizer.sanitize(description)
    desc.length > length ? desc[0...length].rpartition(" ").first + "…" : desc
  end
end

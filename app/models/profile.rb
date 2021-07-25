# frozen_string_literal: true

class Profile < ApplicationRecord
  belongs_to :user

  has_many :event_attendees
  has_many :events, through: :event_attendees

  validates :handle, presence: true

  def to_s
    name
  end
end

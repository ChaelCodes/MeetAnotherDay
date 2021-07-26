# frozen_string_literal: true

# This Profile attends events and share information
# like bio, status, handle, twitch, YouTube, etc
class Profile < ApplicationRecord
  belongs_to :user

  has_many :event_attendees, dependent: :destroy
  has_many :events, through: :event_attendees

  validates :handle, presence: true

  def to_s
    name
  end
end

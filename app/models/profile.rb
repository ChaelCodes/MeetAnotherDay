# frozen_string_literal: true

# This Profile attends events and share information
# like bio, status, handle, twitch, YouTube, etc
# Becomes friends with other Profiles through Friendship
class Profile < ApplicationRecord
  include ::Handleable

  # Attributes
  enum visibility: {
    myself: 0,
    friends: 1,
    # attendees: 2,
    authenticated: 3,
    everyone: 4
  }, _prefix: :visible_to

  # Relationships
  belongs_to :user

  delegate :email, to: :user

  has_many :event_attendees, dependent: :destroy
  has_many :events, through: :event_attendees
  has_many :friendships, class_name: "Friendship", foreign_key: "buddy_id", dependent: :destroy, inverse_of: :buddy

  def to_s
    name
  end

  def attending?(event)
    event_attendees.where(event:).any?
  end

  def event_attendee(event)
    event_attendees.where(event:)
  end

  def friends_with?(profile)
    friendships.accepted.find_by(friend: profile)
  end

  # Friendship Requests for this Profile
  def friend_requests
    friendships.requested
  end
end

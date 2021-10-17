# frozen_string_literal: true

# This Profile attends events and share information
# like bio, status, handle, twitch, YouTube, etc
# Becomes friends with other Profiles through Friendship
class Profile < ApplicationRecord
  include ::Handleable

  belongs_to :user

  has_many :event_attendees, dependent: :destroy
  has_many :events, through: :event_attendees
  # Friendship has a buddy_id and a friend_id (These are both profiles)
  # We want friends to contain all of the profiles that are friends with the current profile
  # Whether they are "buddy" or "friend"
  has_many :buddyships, class_name: "Friendship", foreign_key: "buddy_id", dependent: :destroy, inverse_of: :buddy
  has_many :friendships, class_name: "Friendship", foreign_key: "friend_id", dependent: :destroy, inverse_of: :friend

  def to_s
    name
  end

  def attending?(event)
    event_attendees.where(event: event).any?
  end

  def event_attendee(event)
    event_attendees.where(event: event)
  end

  def friends
    Profile.where(id: friendships.select(:buddy_id).accepted)
           .or(Profile.where(id: buddyships.select(:friend_id).accepted))
  end

  def friends_with?(profile)
    friends.include?(profile)
  end

  def friendship_with(profile)
    Friendship.where(buddy_id: id, friend_id: profile.id)
              .or(Friendship.where(buddy_id: profile.id, friend_id: id)).first
  end

  def friend_requests
    friendships.requested
  end
end

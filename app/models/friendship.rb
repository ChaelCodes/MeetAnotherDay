# frozen_string_literal: true

# This defines the relationship of a "buddy" towards their friend.
# The status describes their feelings towards "friend"
#   - whether they would like to meet up at an event
class Friendship < ApplicationRecord
  belongs_to :buddy, class_name: "Profile"
  alias profile buddy # At some point, we need to rename buddy to profile
  belongs_to :friend, class_name: "Profile"

  has_many :notifications, as: :notifiable, dependent: :destroy

  # accepted means that the buddy would like to see which events
  #   friend is attending, and share their own event attendance
  # blocked means the buddy wants no relationship nor the friend
  #    to see their profile or visibility into events
  # requested means buddy is considering being friends with friend
  enum status: { accepted: 0, blocked: 1, requested: 2 }

  validates :status, presence: true
  validates :friend, comparison: { other_than: :buddy }

  after_commit :manage_notification, on: %i[create update]

  def manage_notification
    Notification.from_friendship(self)
  end

  def self.blocks(profile)
    Friendship.where(friend_id: profile.id).blocked
  end

  def self.friends_of(profile)
    Friendship.where(friend_id: profile.id).accepted
  end

  def to_s
    return "Friendship does not exist yet." unless persisted?
    case status
    when "accepted"
      "#{buddy} feels friendly towards #{friend}!"
    when "blocked"
      "#{buddy} has blocked #{friend}."
    when "requested"
      "#{friend} wants to be friends with #{buddy}!"
    end
  end
end

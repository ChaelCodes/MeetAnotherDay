# frozen_string_literal: true

# This defines the relationship of a "buddy" towards their friend.
# The status describes their feelings towards "friend"
#   - whether they would like to meet up at an event
class Friendship < ApplicationRecord
  include Rails.application.routes.url_helpers

  belongs_to :buddy, class_name: "Profile"
  alias profile buddy # At some point, we need to rename buddy to profile
  belongs_to :friend, class_name: "Profile"

  # accepted means that the buddy would like to see which events
  #   friend is attending, and share their own event attendance
  # blocked means the buddy wants no relationship nor the friend
  #    to see their profile or visibility into events
  # requested means buddy is considering being friends with friend
  enum status: { accepted: 0, blocked: 1, requested: 2 }

  validates :status, presence: true
  validates :friend, comparison: { other_than: :buddy }

  after_commit :manage_notification, on: %i[create update]
  after_destroy_commit :cleanup_notification

  def create_notification
    return unless requested?
    Notification.create_with(message: to_s, url: friendship_url(self, only_path: true))
                .find_or_create_by(notifiable: self, profile: buddy)
  end

  def manage_notification
    Notification.from_friendship(self)
  end

  def cleanup_notification
    # When friendship is destroyed, clean up any associated notifications
    Notification.where(notifiable: self).destroy_all
  rescue StandardError => e
    # Failing notification cleanup shouldn't block friendship destruction
    Rails.logger.warn "Failed to cleanup notification for destroyed friendship: #{e.message}"
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

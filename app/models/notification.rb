# frozen_string_literal: true

# Notification is used to send in-app and email notifications
# to profiles
class Notification < ApplicationRecord
  belongs_to :notifiable, polymorphic: true, optional: true
  belongs_to :profile, optional: true

  validates :message, presence: true

  # Manages notifications for friendship status changes
  # Creates notification for requested friendships, deletes for other statuses
  def self.from_friendship(friendship)
    return unless friendship

    existing_notification = find_by(notifiable: friendship, profile: friendship.buddy)

    if friendship.requested?
      # Create or update notification for friend request
      create_with(
        message: friendship.to_s,
        url: Rails.application.routes.url_helpers.friendship_url(friendship, only_path: true)
      ).find_or_create_by(notifiable: friendship, profile: friendship.buddy)
    elsif existing_notification
      # Delete notification for accepted, blocked, or destroyed friendships
      existing_notification.destroy
    end
  rescue StandardError => e
    # Failing notification management shouldn't block friendship changes
    Rails.logger.warn "Failed to manage notification for friendship #{friendship.id}: #{e.message}"
  end
end

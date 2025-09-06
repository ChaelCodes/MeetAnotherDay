# frozen_string_literal: true

# Notification is used to send in-app and email notifications
# to profiles
class Notification < ApplicationRecord
  include Rails.application.routes.url_helpers

  belongs_to :notifiable, polymorphic: true, optional: true
  belongs_to :profile, optional: true

  validates :message, presence: true

  before_validation :set_url, on: :create, if: -> { notifiable.present? && url.blank? }

  # Manages notifications for friendship status changes
  # Creates notification for requested friendships, deletes for other statuses
  def self.from_friendship(friendship)
    return unless friendship&.persisted?

    if friendship.requested?
      Notification.create_with(message: friendship.to_s)
                  .find_or_create_by(notifiable: friendship, profile: friendship.buddy)
    elsif (existing_notification = find_by(notifiable: friendship))
      # Delete notification for accepted or blocked friendships
      existing_notification.destroy
    end
  end

  def set_url
    self.url ||= url_for notifiable
  end
end

# frozen_string_literal: true

# Notification is used to send in-app and email notifications
# to profiles
class Notification < ApplicationRecord
  belongs_to :notifiable, polymorphic: true, optional: true
  belongs_to :profile, optional: true

  validates :message, presence: true
end

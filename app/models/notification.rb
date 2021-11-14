# frozen_string_literal: true

class Notification < ApplicationRecord
  belongs_to :notifiable, polymorphic: true
  belongs_to :notified, class_name: "Profile", optional: true
  belongs_to :notifier, class_name: "Profile"
end

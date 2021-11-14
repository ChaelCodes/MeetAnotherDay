class Notification < ApplicationRecord
  belongs_to :notifiable, polymorphic: true
  belongs_to :notified
  belongs_to :notifier
end

# frozen_string_literal: true

class Friendship < ApplicationRecord
  # I asked friend to be my buddy
  belongs_to :buddy, class_name: "Profile"
  # I was asked to become a friend by my buddy
  belongs_to :friend, class_name: "Profile"

  enum status: { accepted: 0, declined: 1, ignored: 3, requested: 2 }

  validates :status, presence: true

  # Returns nil if they're not one of the friends
  def not_my_profile(profile)
    return friend if profile.id == buddy_id
    buddy if profile.id == friend_id
  end
end

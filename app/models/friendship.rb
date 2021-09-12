# frozen_string_literal: true

# This defines the relationship between two profiles.
class Friendship < ApplicationRecord
  # I asked friend to be my buddy
  belongs_to :buddy, class_name: "Profile"
  # I was asked to become a friend by my buddy
  belongs_to :friend, class_name: "Profile"

  enum status: { accepted: 0, blocked: 1, requested: 2 }

  validates :status, presence: true
end

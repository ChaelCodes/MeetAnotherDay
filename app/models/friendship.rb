# frozen_string_literal: true

class Friendship < ApplicationRecord
  belongs_to :buddy, class_name: "Profile"
  belongs_to :friend, class_name: "Profile"

  enum status: { accepted: 0, declined: 1, requested: 2 }

  validates :status, presence: true
end

# frozen_string_literal: true

class Profile < ApplicationRecord
  belongs_to :user

  validates :handle, presence: true

  def to_s
    name
  end
end

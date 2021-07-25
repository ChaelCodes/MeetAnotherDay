# frozen_string_literal: true

# Events are events that you can attend.
class Event < ApplicationRecord
  validates :start_at, :end_at, presence: true

  def to_s
    name
  end
end

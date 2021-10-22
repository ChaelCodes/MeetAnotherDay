# frozen_string_literal: true

# Add a organizer column to event_attendees table
class AddOrganizerToEventAtteandance < ActiveRecord::Migration[6.1]
  def change
    add_column :event_attendees, :organizer, :bool, default: false
  end
end

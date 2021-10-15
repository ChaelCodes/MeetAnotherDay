# frozen_string_literal: true

# Add index and unique to handle attribute in the events table
class ChangeHandleToEvents < ActiveRecord::Migration[6.1]
  def change
    add_index :events, :handle, unique: true
  end
end

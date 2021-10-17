# frozen_string_literal: true

# Add a handle column to events table.
# Add index and unique to handle attribute in the events table.
class AddIndexToEvents < ActiveRecord::Migration[6.1]
  def change
    add_column :events, :handle, :string
    add_index :events, :handle, unique: true
  end
end

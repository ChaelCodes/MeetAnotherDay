# frozen_string_literal: true

# Add a handle column to events table
class AddHandleToEvents < ActiveRecord::Migration[6.1]
  def change
    add_column :events, :handle, :string
  end
end

# frozen_string_literal: true

# Add index to handle in the profiles table
class AddIndexHandleToProfles < ActiveRecord::Migration[6.1]
  def change
    add_index :profiles, :handle, unique: true
  end
end

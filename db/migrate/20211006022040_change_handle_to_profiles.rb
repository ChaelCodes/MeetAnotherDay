# frozen_string_literal: true

# Add index and unique to handle attribute in the profiles table
class ChangeHandleToProfiles < ActiveRecord::Migration[6.1]
  def change
    add_index :profiles, :handle, unique: true
  end
end

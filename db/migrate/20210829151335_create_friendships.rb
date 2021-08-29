# frozen_string_literal: true

# Freindships are designed to explain the relationship between two profiles.
class CreateFriendships < ActiveRecord::Migration[6.1]
  def change
    create_table :friendships do |t|
      t.integer :friend_id, null: false
      t.integer :buddy_id, null: false
      t.integer :status, default: 2, null: false

      t.timestamps
      t.index %i[friend_id buddy_id], unique: true
      t.foreign_key :profiles, column: :buddy_id
      t.foreign_key :profiles, column: :friend_id
    end
  end
end

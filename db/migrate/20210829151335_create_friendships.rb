class CreateFriendships < ActiveRecord::Migration[6.1]
  def change
    create_table :friendships do |t|
      t.integer :friendship_id, null: false
      t.integer :buddy_id, null: false
      t.integer :status, default: 2, null: false

      t.timestamps
      t.index [:friendship_id, :buddy_id], unique: true
      t.foreign_key :profiles, column: :buddy_id
      t.foreign_key :profiles, column: :friendship_id
    end
  end
end

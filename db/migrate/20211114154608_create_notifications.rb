# frozen_string_literal: true

# Create a table for Notifications to inform profiles of friend requests
# or inform admins of reported abuse
class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.string :message
      t.references :notifiable, polymorphic: true, null: false
      t.references :notified, null: true, foreign_key: { to_table: :profiles }
      t.references :notifier, null: false, foreign_key: { to_table: :profiles }

      t.timestamps
    end
  end
end

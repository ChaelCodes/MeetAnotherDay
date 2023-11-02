# frozen_string_literal: true

# Create a table for Notifications to inform profiles of friend requests
# or inform admins of reported abuse, or notify on upcoming events
class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.string :message, null: false
      t.references :notifiable, polymorphic: true
      t.references :profile
      t.string :url

      t.references :created_by, polymorphic: true
      t.timestamps
    end
  end
end

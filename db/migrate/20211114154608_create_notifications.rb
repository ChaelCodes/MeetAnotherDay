class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.string :message
      t.references :notifiable, polymorphic: true, null: false
      t.references :notified, null: false, foreign_key: true
      t.references :notifier, null: false, foreign_key: true

      t.timestamps
    end
  end
end

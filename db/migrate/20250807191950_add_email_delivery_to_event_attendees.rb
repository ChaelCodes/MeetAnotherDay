# Add columns to support sending emails to event attendees about upcoming events
class AddEmailDeliveryToEventAttendees < ActiveRecord::Migration[7.1]
  change_table :event_attendees, bulk: true do |t|
    t.column :email_scheduled_on, :date
    t.column :email_delivered_at, :datetime
    t.index :email_scheduled_on,
            where: "email_delivered_at IS NULL",
            algorithm: :concurrently
  end
end

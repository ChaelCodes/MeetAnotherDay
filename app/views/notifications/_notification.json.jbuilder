json.extract! notification, :id, :message, :notifiable_id, :notifiable_type, :notified_id, :notifier_id, :created_at,
              :updated_at
json.url notification_url(notification, format: :json)

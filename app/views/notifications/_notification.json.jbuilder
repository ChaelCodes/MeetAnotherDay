json.extract! notification, :id, :message, :notifiable_id, :notifiable_type, :url,
              :created_by_type, :created_by_id, :created_at, :updated_at
json.url notification_url(notification, format: :json)

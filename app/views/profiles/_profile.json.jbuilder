json.extract! profile, :id, :name, :handle, :bio, :created_at, :updated_at
json.url profile_url(profile, format: :json)

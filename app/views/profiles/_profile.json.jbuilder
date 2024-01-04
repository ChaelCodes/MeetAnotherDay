json.extract! profile, :id, :name, :handle, :bio, :created_at, :updated_at
json.url profile_url(profile, format: :json)
json.profile_picture_url profile_picture(profile.email)

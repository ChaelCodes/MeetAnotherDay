# frozen_string_literal: true

after "development:users" do
  chael = User.find_by(name: "Chael")
  john = User.find_by(name: "John")

  profiles = [
    { name: "Chael's Profile", handle: "chaels_handle", user_id: chael.id },
    { name: "John's Profile", handle: "john_handle", user_id: john.id }
  ]

  profiles.each do |profile|
    Profile.find_or_create_by(profile)
  end
end

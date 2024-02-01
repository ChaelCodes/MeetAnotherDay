# frozen_string_literal: true

after "development:users" do
  chael = User.find_by!(email: "admin@example.com")
  john = User.find_by!(email: "john@example.com")
  everyone = User.find_by!(email: "everyone@example.com")
  authenticated = User.find_by!(email: "authenticated@example.com")
  friends = User.find_by!(email: "friends@example.com")
  myself = User.find_by!(email: "myself@example.com")

  profiles = [
    { name: "Chael's Profile", handle: "chaels_handle", user_id: chael.id },
    { name: "John's Profile", handle: "john_handle", user_id: john.id },
    {
      name: "Everyone Visibility",
      handle: "everyone_handle",
      bio: "This is an Everyone Visibility Profile",
      user_id: everyone.id,
      visibility: :everyone
    },
    {
      name: "Authenticated Visibility",
      handle: "authenticated_handle",
      bio: "This is an Authenticated Visibility Profile",
      user_id: authenticated.id,
      visibility: :authenticated
    },
    {
      name: "Friends Visibility",
      handle: "friends_handle",
      bio: "This is an Friends Visibility Profile",
      user_id: friends.id,
      visibility: :friends
    },
    {
      name: "Myself Visibility",
      handle: "myself_handle",
      bio: "This is an Myself Visibility Profile",
      user_id: myself.id,
      visibility: :myself
    }
  ]

  profiles.each do |profile|
    Profile.find_or_initialize_by(handle: profile[:handle]).update(profile)
  end
end

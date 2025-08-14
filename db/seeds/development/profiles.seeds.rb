# frozen_string_literal: true

after "development:users" do
  chael = User.find_by!(email: "chaelcodes@gmail.com")
  john = User.find_by!(email: "john@example.com")
  everyone = User.find_by!(email: "everyone@example.com")
  authenticated = User.find_by!(email: "authenticated@example.com")
  friends = User.find_by!(email: "friends@example.com")
  myself = User.find_by!(email: "myself@example.com")

  profiles = [
    {
      name: "Rachael Wright-Munn",
      handle: "chaelcodes",
      user_id: chael.id,
      bio: "Software Engineer since 2012 | Live coding on Twitch since 2019 | open-source contributor | " \
           "Programming Game Enthusiast | Featured in 'One Dreamer' video game! ✨ " \
           "Contact me on Discord or conference slack to meet up! " \
           "[More Links](chael.codes/links)"
    },
    {
      name: "John",
      handle: "john_handle",
      user_id: john.id,
      bio: ""
    },
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

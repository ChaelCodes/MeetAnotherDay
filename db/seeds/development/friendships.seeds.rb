# frozen_string_literal: true

after "development:profiles" do
  chael = Profile.find_by(name: "Chael's Profile")
  john = Profile.find_by(name: "John's Profile")

  friends = [
    { friend_id: chael.id, buddy_id: john.id }
  ]

  friends.each do |friend|
    Friendship.find_or_create_by(friend)
  end
end

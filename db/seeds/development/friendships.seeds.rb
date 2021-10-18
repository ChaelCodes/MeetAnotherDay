# frozen_string_literal: true

after "development:users" do
  chael = User.find_by(name: "Chael")
  john = User.find_by(name: "John")

  friends = [
    { friend_id: chael.id, buddy_id: john.id }
  ]

  Friendship.create(friends)
end

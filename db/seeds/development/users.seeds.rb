# frozen_string_literal: true

users = [
  {
    bio: "Hello. I am admin. Friends please? Ty.",
    email: "admin@example.com",
    name: "Chael",
    admin: true
  },
  {
    bio: "Hello. I am dev. Friends please? Ty.",
    email: "john@example.com",
    name: "John",
    admin: false
  }
]

users.each do |user|
  User.create_with(password: "P@55w0rd", confirmed_at: 1.day.ago).find_or_create_by(user)
end

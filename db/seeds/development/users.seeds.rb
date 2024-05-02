# frozen_string_literal: true

users = [
  {
    email: "admin@example.com",
    admin: true
  },
  {
    email: "john@example.com",
    admin: false
  },
  {
    email: "everyone@example.com"
  },
  {
    email: "authenticated@example.com"
  },
  {
    email: "friends@example.com"
  },
  {
    email: "myself@example.com"
  }
]

users.each do |user|
  User.create_with(password: "P@55w0rd", confirmed_at: 1.day.ago).find_or_create_by(user)
end

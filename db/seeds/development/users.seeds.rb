# frozen_string_literal: true

users = [
  {
    bio: "Hello. I am couch. Friends please? Ty.",
    email: "admin@example.com",
    name: "Chael",
    password: "password",
    confirmed_at: 1.day.ago,
    admin: true
  },
  {
    bio: "Hello. I am dev. Friends please? Ty.",
    email: "john@example.com",
    name: "John",
    password: "password",
    confirmed_at: 1.day.ago,
    admin: false
  }
]
User.create(users)

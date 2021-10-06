# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#
users = [
  {
    bio: "Hello. I am couch. Friends please? Ty.",
    email: "admin@example.com",
    name: "Chael",
    password: "P@55w0rd",
    confirmed_at: 1.day.ago,
    admin: true
  },
  {
    bio: "Hello. I am dev. Friends please? Ty.",
    email: "user@example.com",
    name: "Jonh",
    password: "P@55w0rd",
    confirmed_at: 1.day.ago,
    admin: false
  }
]
chael, jonh = User.create(users)

profiles = [
  { name: "Chael's Profile", handle: "chaels_handle", user_id: chael.id },
  { name: "Jonh's Profile", handle: "jonh_handle", user_id: jonh.id }
]
chaels_profile, jonh_profile = Profile.create(profiles)

events = [
  {
    name: "Rails Conf 2021",
    description: "Best place to meet rubyst people",
    start_at: 5.days.from_now,
    end_at: 10.days.from_now
  },
  {
    name: "Vue Conf 2021",
    description: "Best place to meet javascript people",
    start_at: 10.days.from_now,
    end_at: 13.days.from_now
  }
]
rails_conf, vue_conf = Event.create(events)

event_attendees = [
  { profile_id: chaels_profile.id, event_id: rails_conf.id },
  { profile_id: jonh_profile.id, event_id: vue_conf.id }
]
EventAttendee.create(event_attendees)

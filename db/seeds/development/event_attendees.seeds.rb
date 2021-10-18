# frozen_string_literal: true

after "development:events" do
  chael_profile = Profile.find_by(handle: "chaels_handle")
  john_profile = Profile.find_by(handle: "john_handle")

  rails_conf = Event.find_by(handle: "rails_conf_2021")
  vue_conf = Event.find_by(handle: "vue_conf_2021")

  event_attendees = [
    { profile_id: chael_profile.id, event_id: rails_conf.id },
    { profile_id: john_profile.id, event_id: vue_conf.id }
  ]
  EventAttendee.create(event_attendees)
end

# frozen_string_literal: true

after "development:events" do
  after "development:profiles" do
    chael_profile = Profile.find_by!(handle: "chaelcodes")
    john_profile = Profile.find_by!(handle: "john_handle")
    everyone_profile = Profile.find_by!(handle: "everyone_handle")

    rails_conf = Event.find_by!(handle: "railsconf")
    vue_conf = Event.find_by!(handle: "vue_conf")

    event_attendees = [
      { profile_id: chael_profile.id, event_id: rails_conf.id },
      { profile_id: john_profile.id, event_id: vue_conf.id }
    ]

    event_attendees.each do |event_attendee|
      EventAttendee.find_or_create_by(event_attendee)
    end

    # Everyone profile attends all events
    Event.find_each do |event|
      EventAttendee.find_or_create_by(event:, profile_id: everyone_profile.id)
    end

    # Chael's events are preloaded for good demos
    event_handles = %w[rails_conf_2021
                       vue_conf_2021
                       sf_ruby_conf_2025
                       railsconf_2025
                       ruby_retreat_nz_2025
                       blue_ridge_ruby_2024
                       railsconf_2024
                       rubyconf_2023
                       strangeloop_2023
                       ruby_for_good_2023
                       railsconf_2023
                       rubyconf_2021
                       rubyconf_2020
                       railsconf_2018
                       railsconf_2017]
    Event.where(handle: event_handles).find_each do |event|
      EventAttendee.find_or_create_by(event:, profile_id: chael_profile.id)
    end
  end
end

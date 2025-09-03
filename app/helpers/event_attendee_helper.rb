# frozen_string_literal: true

# UI helpers for EventAttendee
module EventAttendeeHelper
  def attend_event_button(event:, profile:)
    button_to "Attend",
              event_attendees_path(
                event_attendee: {
                  event_id: event.id,
                  profile_id: profile.id
                }
              ),
              action: "create",
              class: "button is-primary"
  end
end

# frozen_string_literal: true

# UI helpers for EventAttendees
module EventAttendeesHelper
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

  def email_delivery_text(event_attendee)
    if event_attendee.email_delivered_at
      "Your email about attendees was delivered at #{l(event_attendee.email_delivered_at, format: :long)}."
    elsif event_attendee.email_scheduled_on
      "You will receive an email telling you which friends are attending on " \
        "#{l(event_attendee.email_scheduled_on, format: :long)}."
    else
      "You do not have an email scheduled for this event."
    end
  end
end

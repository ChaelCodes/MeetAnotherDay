# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/event
class EventPreview < ActionMailer::Preview
  def pre_event_email
    event_attendee = EventAttendee.find_by(id: params[:event_attendee_id]) || EventAttendee.first
    EventMailer.with(event_attendee:).pre_event_email
  end
end

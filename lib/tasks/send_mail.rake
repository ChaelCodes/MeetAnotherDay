# frozen_string_literal: true

namespace :send_mail do
  desc "Send an email before the event telling profiles who else is attending"
  task event_attendee: :environment do
    EventAttendee.for_email.find_in_batches do |event_attendees|
      event_attendees.each do |event_attendee|
        EventAttendeeMailer.with(event_attendee:).pre_event_email.deliver_later
      end
      sleep 50
    end
  end
end

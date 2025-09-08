json.event_attendees do
  json.array! @event_attendees, partial: "event_attendees/event_attendee", as: :event_attendee
end
json.links @pagination_links

json.events do
  json.array! @events, partial: "events/event", as: :event
end
json.links @pagination_links

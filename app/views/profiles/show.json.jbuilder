json.partial! "profiles/profile", profile: @profile
json.events do
  json.array! @events, partial: "events/event", as: :event
end

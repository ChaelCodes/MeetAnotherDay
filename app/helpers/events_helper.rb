# frozen_string_literal: true

# Helper for Events
module EventsHelper
  def date_range(event)
    start_date = event.start_at.to_date
    if (event.end_at - event.start_at) >= 1.day
      end_date = event.end_at.to_date
      "#{l(start_date, format: :long)} - #{l(end_date, format: :long)}"
    else
      "#{l(start_date, format: :long)} #{l event.start_at, format: :time} - #{l event.end_at, format: :time}"
    end
  end
end

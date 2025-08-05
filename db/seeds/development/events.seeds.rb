# frozen_string_literal: true

events = [
  {
    name: "Rails Conf",
    handle: "railsconf",
    description: "Best place to meet rubyst people",
    start_at: 5.days.from_now,
    end_at: 10.days.from_now
  },
  {
    name: "Vue Conf",
    handle: "vue_conf",
    description: "Best place to meet javascript people",
    start_at: 10.days.from_now,
    end_at: 13.days.from_now
  },
  {
    name: "ContainerDays 2023",
    handle: "container_days_2023",
    description: "Description",
    start_at: Date.new(2023, 9, 11),
    end_at: Date.new(2023, 9, 13)
  },
  {
    name: "KCD Munich 2024",
    handle: "container_days_2024",
    description: "Description",
    start_at: Date.new(2024, 7, 1),
    end_at: Date.new(2024, 7, 2)
  },
  {
    name: "RubyConf Taiwan x COSCUP 2025",
    handle: "rubyconf_taiwan_2025",
    description: "Description",
    start_at: Date.new(2025, 8, 9),
    end_at: Date.new(2025, 8, 10)
  },
  {
    name: "San Francisco Ruby Conference 2025",
    handle: "sf_ruby_conf_2025",
    description: "Description",
    start_at: Date.new(2025, 11, 19),
    end_at: Date.new(2025, 11, 20)
  },
  {
    name: "Rails Camp West 2025",
    handle: "rails_camp_2025",
    description: "description",
    start_at: Date.new(2025, 8, 18),
    end_at: Date.new(2025, 8, 21)
  },
  {
    name: "Brighton Ruby 2025",
    handle: "brighton_ruby_2025",
    description: "Description",
    start_at: Date.new(2025, 6, 19),
    end_at: Date.new(2025, 6, 19)
  }
]

events.each do |event|
  Event.create_with(event).find_or_create_by(handle: event[:handle])
end

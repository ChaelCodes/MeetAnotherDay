# frozen_string_literal: true

after "development:profiles" do
  events = [
    {
      name: "Rails Conf 2021",
      handle: "rails_conf_2021",
      description: "Best place to meet rubyst people",
      start_at: 5.days.from_now,
      end_at: 10.days.from_now
    },
    {
      name: "Vue Conf 2021",
      handle: "vue_conf_2021",
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
      name: "RailsConf 2025",
      handle: "railsconf_2025",
      description: "description",
      start_at: Date.new(2025, 8, 8),
      end_at: Date.new(2025, 8, 10)
    },
    {
      name: "Brighton Ruby 2025",
      handle: "brighton_ruby_2025",
      description: "Description",
      start_at: Date.new(2025, 6, 19),
      end_at: Date.new(2025, 6, 19)
    },
    {
      name: "Ruby Retreat 2025",
      handle: "ruby_retreat_2025",
      description: "Description",
      start_at: Date.new(2025, 5, 9),
      end_at: Date.new(2025, 5, 12)
    },
    {
      name: "XO Ruby Atlanta 2025",
      handle: "xo_ruby_atl_2025",
      description: "Description",
      start_at: Date.new(2025, 9, 13),
      end_at: Date.new(2025, 9, 13)
    }
  ]

  events.each do |event|
    Event.find_or_create_by(event)
  end
end

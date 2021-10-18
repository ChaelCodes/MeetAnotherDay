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
    }
  ]
  Event.create(events)
end

# frozen_string_literal: true

events = [
  {
    name: "San Francisco Ruby Conference 2025",
    handle: "sf_ruby_conf_2025",
    description: "## SF Ruby is excited to invite you to our premier event: the San Francisco Ruby Conference!!" \
                 "We're gathering ~600 Rubyists in San Francisco—the birthplace of so many legendary Ruby startups, " \
                 "and the city where new ones are being built today. There's no better place to celebrate how far " \
                 "Ruby has come and how much stronger the ecosystem is today, thanks to years of community-driven " \
                 "progress. Join us to share stories, swap ideas, and meet fellow builders who know that " \
                 "Ruby and Rails have never been more powerful for launching and growing something new. Let's keep " \
                 "building the future—together. ❤️" \
                 "[More info](https://sfruby.com)",
    start_at: Date.new(2025, 11, 19),
    end_at: Date.new(2025, 11, 20)
  },
  {
    name: "XO Ruby Atlanta 2025",
    handle: "xo_ruby_atl_2025",
    description: "Atlanta's neighborhoods pulse with creativity and warmth, making the city an ideal location for " \
                 "XO Ruby Atlanta—a single-day, single-track conference designed for locals and regional guests from " \
                 "Atlanta, Birmingham, Nashville, and surrounding areas. This event is tailored for those aiming to " \
                 "learn, connect, and build community, all at a price that keeps it accessible." \
                 "XO Ruby Atlanta is a single-day, single-track conference designed to draw folks in from the city " \
                 "and the region. An approachable $100 ticket price coupled with no need for a hotel or airfare " \
                 "means you can connect with your community without breaking the bank." \
                 "[See more](https://www.xoruby.com/event/atlanta)",
    start_at: Date.new(2025, 9, 13),
    end_at: Date.new(2025, 9, 13)
  },
  {
    name: "RailsConf Philadelphia 2025",
    handle: "railsconf_2025",
    description: "RailsConf is the world's longest-running gathering for the Rails community." \
                 "Since 2006, we have brought together developers and enthusiasts of all levels alongside top " \
                 "community voices and representatives from the world's leading companies and startups built on " \
                 "Ruby and Rails. After nearly 20 years, RailsConf 2025 will be the final gathering of its kind " \
                 "— a tribute to the legacy and future of Rails and the community members who have been part of " \
                 "this journey with us. We hope you'll join us for this last celebration!" \
                 "[More info.](https://railsconf.org)",
    start_at: Date.new(2025, 7, 8),
    end_at: Date.new(2025, 7, 10)
  },
  {
    name: "Ruby Retreat Auckland 2025",
    handle: "ruby_retreat_nz_2025",
    description: "Ruby Retreat was held in Whangaparaoa at Y Shakespear Lodge." \
                 "It was a weekend of camping, coding, and chatting!" \
                 "Not just for Rubyists, Ruby Retreat is for all software developers." \
                 "There will be a broad range of talks on different technical topics, and solace from the busyness " \
                 "of work life. This is a chance to unwind, learn, make friends, and grow." \
                 "[More info.](https://retreat.ruby.nz/)",
    start_at: Date.new(2025, 5, 9),
    end_at: Date.new(2025, 5, 12)
  },
  {
    name: "Blue Ridge Ruby 2024",
    handle: "blue_ridge_ruby_2024",
    description: "“Take a break from the gem mine, and get up to the ridge line.”" \
                 "We spend most of the year heads-down in our own projects and codebases. Once in a while, it's good " \
                 "to step back and survey the horizon, alongside a few companions." \
                 "Join us at Blue Ridge Ruby to learn, get inspired, make new #RubyFriends, build community, and " \
                 "celebrate the language we all love." \
                 "[See more](https://blueridgeruby.com/2024)",
    start_at: Date.new(2024, 5, 30),
    end_at: Date.new(2024, 5, 31)
  },
  {
    name: "RailsConf Detroit 2024",
    handle: "railsconf_2024",
    description: "RailsConf is a yearly conference held in the United States and features 49 talks from various " \
                 "speakers, including keynotes by Nadia Odunayo, Irina Nazarova, John Hawthorn, and Aaron Patterson." \
                 "[See more](https://www.rubyevents.org/events/railsconf-2024/talks)",
    start_at: Date.new(2024, 5, 7),
    end_at: Date.new(2024, 5, 9)
  },
  {
    name: "RubyConf San Diego 2023",
    handle: "rubyconf_2023",
    description: "RubyConf is a yearly conference held in the United States and features 45 talks from various " \
                 "speakers, including keynotes by Yukihiro \"Matz\" Matsumoto, Sharon Steed, and Saron Yitbarek." \
                 "[See more](https://www.rubyevents.org/events/rubyconf-2023/talks)",
    start_at: Date.new(2023, 11, 13),
    end_at: Date.new(2023, 11, 15)
  },
  {
    name: "Strangeloop 2023",
    handle: "strangeloop_2023",
    description: "Strange Loop was a multi-disciplinary conference that brought together the developers and thinkers " \
                 "building tomorrow's technology in fields such as emerging languages, alternative databases, " \
                 "concurrency, distributed systems, security, and the web. Strange Loop was created in 2009 by " \
                 "software developer Alex Miller and later run by a team of St. Louis-based friends and developers " \
                 "under Strange Loop LLC, a for-profit venture. The last event happened in 2023." \
                 "[See more](https://www.thestrangeloop.com/2023/sessions.html)",
    start_at: Date.new(2023, 9, 21),
    end_at: Date.new(2023, 9, 23)
  },
  {
    name: "Ruby For Good 2023",
    handle: "ruby_for_good_2023",
    description: "Ruby for Good holds an annual event where engineers, designers, product managers, and other " \
                 "gooders from all over the globe get together over a long weekend to collaboratively build projects" \
                 "in service of our communities. Gooders stay on-site, and hacking and socializing takes place in " \
                 "communal areas. Questions? Check out the [FAQ](https://rubyforgood.org/events/faq) or drop us a " \
                 "note on " \
                 "[Slack](https://join.slack.com/t/rubyforgood/shared_invite/zt-34b5p4vk3-NWIw6hKs2ma~wm7mYSe0_A) " \
                 "or via email at info@rubyforgood.org.",
    start_at: Date.new(2023, 6, 27),
    end_at: Date.new(2023, 6, 30)
  },
  {
    name: "RailsConf Atlanta 2023",
    handle: "railsconf_2023",
    description: "RailsConf is a yearly conference held in the United States and features 83 talks from various " \
                 "speakers, including keynotes by Aaron Patterson, Rafael Mendonça França, Shani Boston, " \
                 "Eileen M. Uchitelle, and Gary Ware." \
                 "[See more](https://www.rubyevents.org/events/railsconf-2023/talks)",
    start_at: Date.new(2023, 4, 24),
    end_at: Date.new(2023, 4, 26)
  },
  {
    name: "RubyConf Denver 2021",
    handle: "rubyconf_2021",
    description: "RubyConf is a yearly conference and features 95 talks from various speakers, including keynotes by " \
                 "Andrea Guendelman, Elisabeth Hendrickson, and Yukihiro \"Matz\" Matsumoto." \
                 "[See more](https://www.rubyevents.org/events/rubyconf-2021/talks)",
    start_at: Date.new(2021, 11, 8),
    end_at: Date.new(2021, 11, 10)
  },
  {
    name: "RubyConf 2020",
    handle: "rubyconf_2020",
    description: "RubyConf is a yearly conference and features 25 talks from various speakers, including keynotes by " \
                 "Yukihiro \"Matz\" Matsumoto, Ryann Richardson, Kerri Miller, Kent Beck, and Aniyia Williams." \
                 "[See more](https://www.rubyevents.org/events/rubyconf-2020/talks)",
    start_at: Date.new(2020, 11, 17),
    end_at: Date.new(2020, 11, 20)
  },
  {
    name: "RailsConf Pittsburgh 2018",
    handle: "railsconf_2018",
    description: "RailsConf is a yearly conference and features 108 talks from various speakers, including keynotes " \
                 "by David Heinemeier Hansson, Mark Imbriaco, Eileen M. Uchitelle, Sarah Mei, and Aaron Patterson." \
                 "[See more](https://www.rubyevents.org/events/railsconf-2018/talks)",
    start_at: Date.new(2020, 4, 17),
    end_at: Date.new(2020, 4, 19)
  },
  {
    name: "RailsConf Phoenix 2017",
    handle: "railsconf_2017",
    description: "RailsConf is a yearly conference and features 103 talks from various speakers, including keynotes " \
                 "by David Heinemeier Hansson, Justin Searls, Aaron Patterson, Marco Rogers, and Pamela Pavliscak." \
                 "[See more](https://www.rubyevents.org/events/railsconf-2017/talks)",
    start_at: Date.new(2017, 4, 25),
    end_at: Date.new(2017, 4, 27)
  }
]

events.each do |event|
  Event.create_with(event).find_or_create_by(handle: event[:handle])
end

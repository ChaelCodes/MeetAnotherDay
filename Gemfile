# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.2"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem "rails", "~> 8.0.3"

gem "devise" # Use to authenticate user
gem "jsbundling-rails", "~> 1.3.0" # bundle js using webpack - https://github.com/rails/jsbundling-rails
gem "kramdown", "~> 2.3", ">= 2.3.1" # Parse Markdown on Profile/Event pages
gem "pagy", "~> 9.3"
gem "pg", "~> 1.1" # Use postgresql as the database for Active Record
gem "puma", "~> 7" # Use Puma as the app server
gem "pundit" # use pundit to control app premissions and policies
gem "rails_cloudflare_turnstile", "~> 0.4"
gem "reactionview", "~> 0.1.4"
gem "rqrcode", "~> 3.1" # Generate QR codes
gem "sass-rails", ">= 6" # Use SCSS for stylesheets
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem "turbolinks", "~> 5"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.7"
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.4.4", require: false

# Seedbank allows you to structure your apps seed data instead of having it all dumped into one large file
gem "seedbank"

group :development, :test do
  gem "factory_bot"
  gem "factory_bot_rails"
  gem "pry"
  gem "rexml"
  gem "rspec-rails"
  gem "rubocop", "~> 1.80.2"
  gem "rubocop-capybara", require: false
  gem "rubocop-factory_bot", require: false
  gem "rubocop-performance", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false
  gem "rubocop-rspec_rails", require: false
end

group :development do
  gem "listen", "~> 3.3"
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem "rack-mini-profiler", "~> 4.0"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem "web-console", ">= 4.1.0"
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem "capybara", ">= 3.26"
  gem "selenium-webdriver", "~> 4.36.0"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

gem "pg_search", "~> 2.3"

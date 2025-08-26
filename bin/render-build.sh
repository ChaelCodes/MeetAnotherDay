#!/usr/bin/env bash

# exit on any error or unset variable
set -euo pipefail

# ensures nokogiri uses ruby instead of native extensions so the render build will succeed.
bundle config set force_ruby_platform true

bundle install --deployment --without development test
bundle exec rails assets:precompile
bundle exec rails assets:clean
bundle exec rake db:migrate
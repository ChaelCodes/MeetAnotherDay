#!/usr/bin/env bash

# exit on any error or unset variable
set -euo pipefail

bundle config set --local deployment 'true'
bundle config set --local without 'development test'
bundle config set --local force_ruby_platform false

bundle install

bundle exec rails assets:precompile
bundle exec rails assets:clean
bundle exec rake db:migrate
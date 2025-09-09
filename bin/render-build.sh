#!/usr/bin/env bash

# exit on any error or unset variable
set -euo pipefail

bundle install --deployment --without development test
bundle exec rails assets:precompile
bundle exec rails assets:clean
bundle exec rake db:migrate
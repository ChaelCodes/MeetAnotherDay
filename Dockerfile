FROM ruby:3.2.2-alpine

RUN apk update && apk upgrade && apk add --update --no-cache \
  build-base \
  nodejs \
  postgresql-dev \
  tzdata \
  yarn && rm -rf /var/cache/apk/*

COPY Gemfile Gemfile.lock /app/

WORKDIR /app/

# ensure nokogiri uses ruby instead of native extensions
# which is helpful for render build
RUN bundle config set force_ruby_platform true

RUN bundle install

ENTRYPOINT ["./scripts/remove_server_pid.sh"]
CMD bundle exec rails server -b 0.0.0.0 -p 3000

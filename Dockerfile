FROM ruby:3.0.1-alpine

RUN apk update && apk upgrade && apk add --update --no-cache \
  build-base \
  nodejs \
  postgresql-dev \
  tzdata \
  yarn && rm -rf /var/cache/apk/*

COPY Gemfile Gemfile.lock /app/

WORKDIR /app/

RUN bundle install --jobs=2

ENTRYPOINT ["./scripts/remove_server_pid.sh"]
CMD bundle exec rails server -b 0.0.0.0 -p 3000

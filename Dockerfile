FROM ruby:3.2.2

RUN apt-get update

COPY Gemfile Gemfile.lock /app/

WORKDIR /app/

RUN bundle install

ENTRYPOINT ["./scripts/remove_server_pid.sh"]
CMD bundle exec rails server -b 0.0.0.0 -p 3000

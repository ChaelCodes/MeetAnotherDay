# ConfBuddies
An app to help you find and meetup with your buddies at conferences.

# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

# Environment Setup
This application has a development environment that supports docker.

Run `docker compose up -d` and the application should be available at localhost:3000.

If the database has not been started, `docker compose run --rm web bundle exec rake db:create`

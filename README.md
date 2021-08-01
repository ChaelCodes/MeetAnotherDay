# ConfBuddies
An app to help you find and meet up with your buddies at conferences.

Have you ever gone to a conference, met someone really cool who lives halfway around the world, and then promptly fell out of touch as soon as the conference was over? A year later, you don't remember their name, but you remember that you met someone really cool at this conference last time you went. ConfBuddies help you manage those relationships! Friend someone while you're at the conference, and when you go to future conferences, find out who else is going!

# Tech Stack

Tech | Version | Use
--- | ---
[Ruby on Rails](https://guides.rubyonrails.org/) | 6.1 | A web application framework built using Ruby that manages interfacing with the database, and responding to web requests
[Postgres](https://www.postgresql.org/docs/13/index.html) | 13 | Database for storing events, users, and all other data

# Contributing
Feel free to contirubte PRs, Issues, Documentation, or in any other way to this repo. The UI stack has not been formalized yet. So it is deliberately brutalist.

# Dev Environment Setup
This application has a development environment that supports Docker.

## First time setup
1. Setup web/db containers. `docker compose up -d`
1. Run database migrations. `docker compose run --rm web bundle exec rake db:create`
1. The application should be available at [localhost:3000](localhost:3000)

## Daily use
Run `docker compose up -d` and the application should be available at [localhost:3000](localhost:3000).

## Trouble-shooting
If you run into an issue with shared mounts on WSL, (`error message: Error response from daemon: path /home/<>/ConfBuddies is mounted on / but it is not a shared mount.`) you may want to try `sudo mount --make-shared /`.

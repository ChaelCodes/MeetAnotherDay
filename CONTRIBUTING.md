# Contributing
Feel free to contribute PRs, Issues, Documentation, or in any other way to this repo. We welcome new ideas, implementation suggestions, and feedback!

# Dev Environment Setup
This application has a development environment that supports Docker. We believe this makes it easier to get started with the application.

## First time setup
1. Setup web and db containers. `docker compose up -d`
1. Run database migrations. `docker compose run --rm web bundle exec rake db:create`
1. The application should be available at [localhost:3000](localhost:3000)

## Daily use
Run `docker compose up -d` and the application should be available at [localhost:3000](localhost:3000).

## Testing
Run `docker compose run --rm web bundle exec rspec` to run the test suite. We have GitHub Actions setup to run the test suite automatically. We expect new tests for new functionality, and your PR to having a passing test suite before review.

## Teardown
When you're done, run `docker compose down` to stop the containers. You can remove all containers, images, and volumes with `docker compose rm -v` when you're done contributing to ConfBuddies.

## Trouble-shooting
If you run into an issue with shared mounts on WSL, (`error message: Error response from daemon: path /home/<>/ConfBuddies is mounted on / but it is not a shared mount.`) you may want to try `sudo mount --make-shared /`.

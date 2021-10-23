# Contributing
Feel free to contribute PRs, Issues, Documentation, or in any other way to this repo. We welcome new ideas, implementation suggestions, and feedback!

# Dev Environment Setup
This application has a development environment that supports Docker. We believe this makes it easier to get started with the application.
To get started, you will need either Docker [desktop](https://docs.docker.com/desktop/#download-and-install) or Docker [engine](https://docs.docker.com/engine/install) as well as
Docker Compose which is a tool that is used for defining and running multi-container Docker applications. In our case for running the web application, database and selenium for testing,

Please note:
Older versions of Docker that were released before version 2 and the [new docker compose command](https://docs.docker.com/compose/cli-command/#compose-v2-and-the-new-docker-compose-command) will have to use a hyphen in these commands instead.
For example running `docker-compose` instead of `docker compose` listed in the examples below.

## Working with the repository
<details>
  <summary>We use Forked Repos - Learn More! 🚀</summary>

  _When contributing to the repository we use a **Fork**._

  ### Forking
  Incase you are not aware of what a fork is here is a description from the [about forks](https://docs.github.com/en/github/collaborating-with-pull-requests/working-with-forks/about-forks) resource on Github.

  > A fork is a copy of a repository that you manage. Forks let you make changes to a project without affecting the original repository. You can fetch updates from or submit changes to the original repository with pull requests.

  To fork a project all you have to do is click fork in the top right of the repository page. See image below from https://guides.github.com/activities/forking/

  ![Forking a repo](https://github-images.s3.amazonaws.com/help/bootcamp/Bootcamp-Fork.png)

  Once this is done you will have your own version of ConfBuddies in a url that looks like this `https://github.com/YOUR_USERNAME/ConfBuddies.git`. To get started on this you can clone the repository and make changes for your contributions. If you aren't sure how to do this then we recommend looking at this guide on [cloning a repository](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository)

  ### Keeping up to date (Syncing)
  In order to keep a fork up to date we need to pull from the upstream repo which will be the original ConfBuddies repo.
  This can be setup by running `git remote add upstream https://github.com/ChaelCodes/ConfBuddies.git`

  Again if unsure please take a look at [Configuring a remote for a fork.](https://docs.github.com/en/github/collaborating-with-pull-requests/working-with-forks/configuring-a-remote-for-a-fork)

  In order to pull changes from the original repo into the fork, we need to fetch the upstream. This can be done either by the [UI on Github](https://docs.github.com/en/github/collaborating-with-pull-requests/working-with-forks/syncing-a-fork#syncing-a-fork-from-the-web-ui) or the from [within your terminal](https://docs.github.com/en/github/collaborating-with-pull-requests/working-with-forks/syncing-a-fork#syncing-a-fork-from-the-command-line).

  This can be done in 3 steps:
  - `git fetch upstream` in order to fetch the changes that have been made
  - `git checkout main` to switch to the default branch
  - `git merge upstream/main` to merge the changes from the original repository into your copy.
</details>

## First time setup
1. Setup web and db containers. `docker compose up -d`
1. Create the database. `docker compose run --rm web bundle exec rake db:setup`

## Daily use
Run `docker compose up -d` will run those services in the background and the application should be available at [localhost:3000](localhost:3000).
Run `docker ps` to see all of the running services which are defined in `docker-compose.yml`.

## Testing
Run `docker compose run --rm web bundle exec rspec` to run the test suite. We have GitHub Actions setup to run the test suite automatically. We expect new tests for new functionality, and your PR to having a passing test suite before review.

## Teardown
When you're done, run `docker compose down` to stop the containers. You can remove all containers, images, and volumes with `docker compose rm -v` when you're done contributing to ConfBuddies.

## Helpful Docker Commands
To open the Rails console:\
`docker compose run --rm web bin/rails c`

To open the Postgres console:\
`docker compose exec db psql -U postgres ConfBuddies_development`

To run your tests:\
`docker compose run --rm web bundle exec rspec`

To run rubocop:\
`docker compose run --rm web bundle exec rubocop`

To reset the database with the seed data:
1. (If server was running) Shut down the web server: `docker compose stop web`
2. Reset the DB: `docker-compose run web bundle exec rake db:reset`
3. (If server was running) Bring the web server back up: `docker compose start web`

## Updating Node Modules
You'll have to update your node_modules folder if you see a message similar to the one below.
```
web_1           | ========================================
web_1           |   Your Yarn packages are out of date!
web_1           |   Please run `yarn install --check-files` to update.
web_1           | ========================================
```

If you update package.json or yarn.lock you'll want to rebuild that module. There might be a more efficient way, but you can run:
```
> docker compose run --rm web yarn install --check-files
```

## Running Migrations
If you see the following error, that means there are database change that haven't been applied.
```
Migrations are pending. To resolve this issue, run:
bin/rails db:migrate RAILS_ENV=development
```
Run this docker command to apply the changes.
```
docker compose run --rm web bundle exec rake db:migrate
```

## Trouble-shooting
If you run into an issue with shared mounts on WSL, (`error message: Error response from daemon: path /home/<>/ConfBuddies is mounted on / but it is not a shared mount.`) you may want to try `sudo mount --make-shared /`.

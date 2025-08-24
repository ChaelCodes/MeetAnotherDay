# Meet Another Day

Meet Another Day is a Ruby on Rails 7.1 web application that helps you meet up with your friends at conferences. One week before an event, you'll receive an email with a list of friends attending. Built with Ruby 3.2.2, PostgreSQL 13, and uses Bulma CSS framework with Material Icons.

**Always reference these instructions first and fallback to search or bash commands only when you encounter unexpected information that does not match the info here.**

## Working Effectively

### Development Environment Setup

**Automated Setup (Recommended):**
The repository includes a GitHub Action that automatically sets up a complete development environment. This action:
- Installs Ruby 3.2.2 and all gem dependencies
- Sets up PostgreSQL 13 with proper credentials
- Creates and migrates the database
- Validates the complete setup

**To use the automated setup:**
1. The GitHub Action `.github/workflows/copilot-setup.yml` provides a complete development environment
2. This action can be referenced for exact setup steps and environment configuration
3. All dependencies, database setup, and validation commands are included

**Running the application:**
```bash
# Start the Rails server (starts in ~5 seconds)
POSTGRES_USER=postgres POSTGRES_PASSWORD=password bundle exec rails server -b 0.0.0.0 -p 3000
```
Server serves at http://localhost:3000 and should show "Meet Another Day" homepage.

## Testing and Validation

### Running Tests
```bash
# Run full test suite (407 tests in ~14 seconds - NEVER CANCEL)
POSTGRES_USER=postgres POSTGRES_PASSWORD=password bundle exec rspec --format progress
```
**Critical notes:**
- All tests should pass
- Tests include Capybara/Selenium browser tests for UI validation
- If Selenium tests fail, ensure Chrome/Chromium is available
- Test database is automatically prepared before test runs

### Code Quality
```bash
bundle exec rubocop --auto-correct-all
```

## Validation Scenarios

**ALWAYS test the following after making changes:**

1. **Basic application startup:**
   ```bash
   POSTGRES_USER=postgres POSTGRES_PASSWORD=password bundle exec rails server
   curl http://localhost:3000  # Should return 200 status
   ```

2. **Run test suite:**
   ```bash
   POSTGRES_USER=postgres POSTGRES_PASSWORD=password bundle exec rspec
   # Should complete in ~14 seconds and all tests should pass
   ```

4. **Code style validation:**
   ```bash
   bundle exec rubocop
   ```

## Critical Environment Notes

### Ruby Version Compatibility
- Gemfile specifies Ruby 3.2.2 (exact version required)
- **CRITICAL:** Never change the Ruby version in Gemfile or Gemfile.lock as this can break deployment
- Use Ruby version management tools (rbenv, rvm) to install the exact required version
- If you need a different Ruby version, request it through a comment rather than changing files

## Common Tasks and Commands

### Repository Structure (Key Directories)
```
app/                    # Rails application code
  ├── controllers/      # Request handling
  ├── models/          # Database models  
  ├── views/           # Templates
  └── javascript/      # Frontend JavaScript
config/                # Rails configuration
  ├── database.yml     # Database configuration
  └── environments/    # Environment-specific settings
db/                    # Database migrations and seeds
spec/                  # RSpec test files
public/                # Static assets (compiled)
vendor/bundle/         # Bundled gems (if using --path)
```

### Helpful Development Commands
```bash
# Rails console
POSTGRES_USER=postgres POSTGRES_PASSWORD=password bundle exec rails console

# Database reset with seed data
POSTGRES_USER=postgres POSTGRES_PASSWORD=password bundle exec rails db:reset

# Generate new migration
bundle exec rails generate migration AddFieldToModel field:type

# Check routes
bundle exec rails routes

# View logs
tail -f log/development.log
```

### Docker Commands (If Working)
```bash
# Start services
docker compose up -d

# Rails console in Docker
docker compose run --rm web bin/rails c

# Run tests in Docker  
docker compose run --rm web bundle exec rspec

# Database reset in Docker
docker compose run web bundle exec rake db:reset
```

## Troubleshooting

### "Connection refused" Database Errors
- Ensure PostgreSQL is running: `sudo service postgresql start`
- Verify user exists: `sudo -u postgres createuser -s $(whoami)`
- Always use environment variables: `POSTGRES_USER=postgres POSTGRES_PASSWORD=password`

### Bundle Install Failures
- Use `--path vendor/bundle` to install gems locally
- Fix permissions: `sudo chown -R $USER:$USER .`

### Test Failures
- Ensure database is migrated: `POSTGRES_USER=postgres POSTGRES_PASSWORD=password bundle exec rails db:test:prepare`
- Check test database permissions
- Full test suite should take ~14 seconds and pass all tests

## Application Architecture

**Tech Stack:**
- **Backend:** Ruby on Rails 7.1.x
- **Database:** PostgreSQL 13
- **Frontend:** Bulma CSS framework with Cyborg theme
- **Authentication:** Devise gem
- **Authorization:** Pundit gem
- **Icons:** Material Design Icons
- **Testing:** RSpec with Factory Bot

**Key Models:**
- User (with Devise authentication)
- Profile (user profile information)
- Event (conference events)
- EventAttendee (join table for profile-event relationships)
- Friendship (profile relationships)
- Notification (profile notifications)

The application is deployed on Render with automatic deployments from the main branch.
# Meet Another Day

Meet Another Day is a Ruby on Rails 7.1 web application that helps you find and meet up with your buddies at conferences. Built with Ruby 3.2.2, PostgreSQL 13, and uses Bulma CSS framework with Material Icons.

**Always reference these instructions first and fallback to search or bash commands only when you encounter unexpected information that does not match the info here.**

## Working Effectively

### Local Development Setup (Recommended)

**Prerequisites:**
- Ruby 3.2.2 (if you have 3.2.3, temporarily update Gemfile ruby version to match)
- PostgreSQL 13+ 
- Node.js 20+ and Yarn for JavaScript assets
- Bundler gem installed

**Complete setup commands (run in order):**
```bash
# 1. Install Ruby dependencies (2-3 minutes - NEVER CANCEL)
bundle install --path vendor/bundle

# 2. Install JavaScript dependencies (~6 seconds)
yarn install

# 3. Setup PostgreSQL service
sudo service postgresql start
sudo -u postgres createuser -s $(whoami)
sudo -u postgres psql -c "ALTER USER postgres PASSWORD 'password';"

# 4. Setup database with environment variables (~30 seconds)
POSTGRES_USER=postgres POSTGRES_PASSWORD=password bundle exec rails db:create
POSTGRES_USER=postgres POSTGRES_PASSWORD=password bundle exec rails db:migrate

# 5. Build JavaScript assets (~1 second)
npm run build

# 6. Test the setup
POSTGRES_USER=postgres POSTGRES_PASSWORD=password bundle exec rails runner "puts 'Database connection: OK'; puts 'User count: ' + User.count.to_s"
```

**Running the application:**
```bash
# Start the Rails server (starts in ~5 seconds)
POSTGRES_USER=postgres POSTGRES_PASSWORD=password bundle exec rails server -b 0.0.0.0 -p 3000
```
Server serves at http://localhost:3000 and should show "Meet Another Day" homepage.

### Docker Development Setup (Alternative - Has Known Issues)

**Current limitation:** Docker setup fails in some environments due to SSL certificate verification issues during bundle install. Use local development as primary approach.

If Docker works in your environment:
```bash
# First time setup
docker compose up -d          # NEVER CANCEL - takes 5+ minutes for initial build
docker compose run --rm web bundle exec rake db:setup
```

## Testing and Validation

### Running Tests
```bash
# Run full test suite (407 tests in ~14 seconds - NEVER CANCEL)
POSTGRES_USER=postgres POSTGRES_PASSWORD=password bundle exec rspec --format progress
```
**Critical notes:**
- All 407 tests should pass
- Tests include Capybara/Selenium browser tests for UI validation
- If Selenium tests fail, ensure Chrome/Chromium is available
- Test database is automatically prepared before test runs

### Code Quality
```bash
# Run linter (has warnings about missing rubocop-discourse but works)
bundle exec rubocop --auto-correct-all
```
**Known issue:** Rubocop reports missing `rubocop-discourse` gem but continues to work. This is a dependency issue from bundled gems and can be ignored.

### Asset Compilation
```bash
# JavaScript build
npm run build                 # ~1 second

# Rails asset precompilation  
POSTGRES_USER=postgres POSTGRES_PASSWORD=password bundle exec rails assets:precompile  # ~3-4 seconds
```

## Validation Scenarios

**ALWAYS test the following after making changes:**

1. **Basic application startup:**
   ```bash
   POSTGRES_USER=postgres POSTGRES_PASSWORD=password bundle exec rails server
   curl http://localhost:3000  # Should return 200 status
   ```

2. **Database connectivity test:**
   ```bash
   POSTGRES_USER=postgres POSTGRES_PASSWORD=password bundle exec rails console
   # In console: User.count (should not error)
   ```

3. **Run test suite:**
   ```bash
   POSTGRES_USER=postgres POSTGRES_PASSWORD=password bundle exec rspec
   # Should complete in ~14 seconds with 407 passing tests
   ```

4. **Code style validation:**
   ```bash
   bundle exec rubocop
   # May show warnings about rubocop-discourse but should complete
   ```

## Critical Environment Notes

### Database Configuration
The application uses these environment variables for database connection:
- `POSTGRES_USER=postgres` 
- `POSTGRES_PASSWORD=password`
- `DATABASE_HOST=localhost` (default)

Always include these environment variables when running Rails commands that touch the database.

### Ruby Version Compatibility
- Gemfile specifies Ruby 3.2.2
- If you have Ruby 3.2.3, temporarily change the Gemfile ruby version to match your installed version
- Bundler will work with minor version differences but requires exact match in Gemfile

### JavaScript Build Process
- Uses Webpack 5 for bundling JavaScript
- Build output goes to `public/assets/`
- Run `npm run build` after making JavaScript changes
- May see browserslist warnings - these are safe to ignore

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
- For Docker: SSL certificate issues may require local development instead

### Asset Compilation Issues
- Run `yarn install` first to ensure dependencies
- Use `npm run build` for JavaScript compilation
- Clear assets: `bundle exec rails assets:clean`

### Test Failures
- Ensure database is migrated: `POSTGRES_USER=postgres POSTGRES_PASSWORD=password bundle exec rails db:test:prepare`
- Check test database permissions
- Full test suite should take ~14 seconds and pass all 407 tests

### Rubocop Warnings
- Missing `rubocop-discourse` warnings are expected and can be ignored
- These come from gem dependencies and don't affect functionality
- Auto-correct still works: `bundle exec rubocop --auto-correct-all`

## Application Architecture

**Tech Stack:**
- **Backend:** Ruby on Rails 7.1.x
- **Database:** PostgreSQL 13
- **Frontend:** Bulma CSS framework with Cyborg theme
- **JavaScript:** Webpack 5 bundling, Turbolinks for navigation
- **Authentication:** Devise gem
- **Authorization:** Pundit gem
- **Icons:** Material Design Icons
- **Testing:** RSpec with Factory Bot

**Key Models:**
- User (with Devise authentication)
- Profile (user profile information)
- Event (conference events)
- EventAttendee (join table for user-event relationships)
- Friendship (user relationships)
- Notification (user notifications)

The application is deployed on Render with automatic deployments from the main branch.
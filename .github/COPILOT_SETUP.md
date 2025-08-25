# GitHub Copilot Environment Setup Documentation

This directory contains the setup configuration for GitHub Copilot development environment.

## Files

### 1. `copilot-setup.sh`
Main setup script that automatically detects and configures the development environment. Features:
- **Docker-first approach**: Uses Docker when available for consistent environment
- **Fallback to local setup**: Works with local Ruby/PostgreSQL installation
- **Automatic dependency management**: Handles Ruby gems, Node.js packages, database setup
- **Comprehensive validation**: Tests database connectivity, code style, and full test suite

### 2. `copilot-environment.yml`
YAML configuration file defining the development environment structure for GitHub Copilot.

### 3. `../workflows/dev-environment-setup.yml`
GitHub Actions workflow for CI/CD environment setup (moved from copilot-setup.yml).

## Usage

### Quick Start (Recommended)
```bash
# Run the setup script
./.github/copilot-setup.sh
```

### Docker Setup (Exact Environment)
```bash
# Use Docker for exact Ruby 3.2.2 environment
docker compose build
docker compose up -d db
docker compose run --rm web bundle install
docker compose run --rm web bundle exec rails db:create db:migrate
docker compose up web
```

### Manual Setup
```bash
# Install dependencies
bundle install
yarn install

# Setup database
bundle exec rails db:create
bundle exec rails db:migrate

# Run validations
bundle exec rubocop
bundle exec rspec
```

## Environment Requirements

- **Ruby**: 3.2.2 (exactly, as specified in Gemfile)
- **PostgreSQL**: 13+
- **Node.js**: 18+ (for asset compilation)
- **Docker**: Optional but recommended for exact environment replication

## Validation Commands

The setup includes these validation steps:
1. Database connectivity test
2. Code style validation with RuboCop
3. Full test suite execution (407 tests)

## Troubleshooting

### Ruby Version Mismatch
If you encounter Ruby version mismatches (e.g., 3.2.3 vs 3.2.2), use Docker:
```bash
docker compose run --rm web ./.github/copilot-setup.sh
```

### Database Connection Issues
Ensure PostgreSQL is running and environment variables are set:
```bash
export POSTGRES_USER=postgres
export POSTGRES_PASSWORD=password
```

### Permission Issues
Use local bundle path to avoid system permission conflicts:
```bash
bundle config set --local path vendor/bundle
```

## For GitHub Copilot

This setup ensures GitHub Copilot has a fully functional Rails development environment with:
- Proper Ruby/Rails environment
- Database connectivity
- Test framework setup
- Code quality tools
- Development server capability

The environment can be started with:
```bash
# Docker (recommended)
docker compose up web

# Local
bundle exec rails server -b 0.0.0.0 -p 3000
```

Application will be available at http://localhost:3000
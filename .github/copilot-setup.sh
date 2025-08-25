#!/bin/bash
# GitHub Copilot Development Environment Setup Script
# This script sets up the complete development environment for Meet Another Day

set -e

echo "🚀 Setting up Meet Another Day development environment..."

# Environment variables
export POSTGRES_USER=${POSTGRES_USER:-postgres}
export POSTGRES_PASSWORD=${POSTGRES_PASSWORD:-password}
export RAILS_ENV=${RAILS_ENV:-development}

echo "📦 Installing system dependencies..."
# Install required system packages
if command -v apt-get >/dev/null 2>&1; then
    sudo apt-get update
    sudo apt-get install -y postgresql-client curl build-essential
fi

echo "💎 Checking Ruby version..."
# Check Ruby version (allow 3.2.x versions)
RUBY_VERSION=$(ruby --version | grep -o "3\.2\.[0-9]")
if [[ ! "$RUBY_VERSION" =~ ^3\.2\.[0-9]+$ ]]; then
    echo "⚠️  Ruby 3.2.x is required. Current version: $(ruby --version)"
    echo "Please install Ruby 3.2.x using rbenv, rvm, or your system package manager."
    exit 1
else
    echo "✅ Ruby $RUBY_VERSION detected (compatible with 3.2.2)"
fi

echo "📚 Installing Ruby dependencies..."
# Install Ruby gems using local path to avoid permission issues
bundle config set --local path vendor/bundle

# Check if we need to handle Ruby version mismatch
if ! bundle check > /dev/null 2>&1; then
    echo "Installing gems (this may take a few minutes)..."
    # Try to install gems, handling Ruby version differences gracefully
    if ! bundle install; then
        echo "⚠️  Bundle install failed. This may be due to a Ruby version mismatch."
        echo "The Gemfile specifies Ruby 3.2.2, but system has $(ruby --version)"
        echo "For development purposes, this is usually acceptable."
        echo "If you encounter issues, please install Ruby 3.2.2 exactly."
        
        # For CI/development environments, we can be more flexible
        echo "Attempting to continue with current Ruby version..."
        export BUNDLE_GEMFILE=Gemfile
        bundle install --no-cache --full-index || {
            echo "❌ Could not install dependencies. Please check Ruby version."
            exit 1
        }
    fi
else
    echo "✅ Dependencies already installed"
fi

echo "🐘 Setting up PostgreSQL database..."
# Create and migrate database
bundle exec rails db:create
bundle exec rails db:migrate

echo "📦 Installing Node.js dependencies..."
# Install Node.js packages
if [ -f "package.json" ]; then
    yarn install
else
    echo "⚠️  package.json not found, skipping Node.js dependencies"
fi

echo "🔍 Validating setup..."
# Test database connection
echo "Testing database connectivity..."
bundle exec rails runner \
    "puts 'Database connection: OK'; \
    puts 'User count: ' + User.count.to_s"

echo "🎨 Running code style validation..."
bundle exec rubocop --auto-correct-all

echo "🧪 Running test suite..."
bundle exec rspec --format progress

echo "✅ Development environment setup complete!"
echo "🌐 Start the server with: bundle exec rails server -b 0.0.0.0 -p 3000"
echo "📖 Visit http://localhost:3000 to see the application"
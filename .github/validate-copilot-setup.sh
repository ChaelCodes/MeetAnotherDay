#!/bin/bash
# GitHub Copilot Setup Validation Script
# This script validates the setup configuration without requiring full environment

set -e

echo "🔍 Validating GitHub Copilot setup configuration..."

# Check if all required files exist
echo "📁 Checking setup files..."
REQUIRED_FILES=(
    ".github/copilot-setup.sh"
    ".github/copilot-environment.yml" 
    ".github/COPILOT_SETUP.md"
    ".github/workflows/dev-environment-setup.yml"
    "Dockerfile"
    "docker-compose.yml"
    "Gemfile"
    "package.json"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file"
    else
        echo "❌ $file (missing)"
        exit 1
    fi
done

# Check if setup script is executable
if [ -x ".github/copilot-setup.sh" ]; then
    echo "✅ Setup script is executable"
else
    echo "❌ Setup script is not executable"
    exit 1
fi

# Validate YAML files
echo "📝 Validating YAML syntax..."
if command -v python3 >/dev/null 2>&1; then
    python3 -c "import yaml; yaml.safe_load(open('.github/copilot-environment.yml'))" && echo "✅ copilot-environment.yml is valid YAML"
    python3 -c "import yaml; yaml.safe_load(open('docker-compose.yml'))" && echo "✅ docker-compose.yml is valid YAML"
    python3 -c "import yaml; yaml.safe_load(open('.github/workflows/dev-environment-setup.yml'))" && echo "✅ dev-environment-setup.yml is valid YAML"
else
    echo "⚠️  Python3 not available, skipping YAML validation"
fi

# Check Ruby version specification
echo "💎 Checking Ruby version specification..."
if grep -q "ruby \"3.2.2\"" Gemfile; then
    echo "✅ Gemfile specifies Ruby 3.2.2"
else
    echo "❌ Gemfile does not specify Ruby 3.2.2"
    exit 1
fi

# Check Docker configuration
echo "🐳 Checking Docker configuration..."
if grep -q "FROM ruby:3.2.2" Dockerfile; then
    echo "✅ Dockerfile uses Ruby 3.2.2"
else
    echo "❌ Dockerfile does not use Ruby 3.2.2"
    exit 1
fi

# Check PostgreSQL configuration
echo "🐘 Checking PostgreSQL configuration..."
if grep -q "postgres:13" docker-compose.yml; then
    echo "✅ docker-compose.yml uses PostgreSQL 13"
else
    echo "❌ docker-compose.yml does not use PostgreSQL 13"
    exit 1
fi

# Check environment files
echo "⚙️  Checking environment configuration..."
if [ -f "config/docker.env" ]; then
    echo "✅ Docker environment file exists"
    if grep -q "POSTGRES_USER=postgres" config/docker.env; then
        echo "✅ PostgreSQL user configured"
    else
        echo "❌ PostgreSQL user not configured in docker.env"
        exit 1
    fi
else
    echo "❌ config/docker.env missing"
    exit 1
fi

# Check if required directories exist
echo "📂 Checking directory structure..."
REQUIRED_DIRS=(
    "app"
    "config"
    "db"
    "spec"
    ".github"
)

for dir in "${REQUIRED_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        echo "✅ $dir/"
    else
        echo "❌ $dir/ (missing)"
        exit 1
    fi
done

echo ""
echo "🎉 GitHub Copilot setup validation completed successfully!"
echo ""
echo "📋 Summary:"
echo "  • Setup script: .github/copilot-setup.sh (executable)"
echo "  • Environment config: .github/copilot-environment.yml"
echo "  • Documentation: .github/COPILOT_SETUP.md"
echo "  • Workflow: .github/workflows/dev-environment-setup.yml"
echo "  • Ruby version: 3.2.2 (Dockerfile and Gemfile)"
echo "  • PostgreSQL: 13 (docker-compose.yml)"
echo "  • All required files and directories present"
echo ""
echo "🚀 To use the setup:"
echo "  • Run: ./.github/copilot-setup.sh"
echo "  • Or with Docker: docker compose up"
echo "  • Documentation: cat .github/COPILOT_SETUP.md"
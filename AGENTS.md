- Use bulma classes over building your own. I'm fine with minimal UI issues if it allows us to reduce complexity and custom styling.
- Prefer using libraries and frameworks over building custom javascript, css, or other code.
- Do not add external dependencies without explicit permission in the issue or PR.

# Standard Practices
- Run `bundle install` after you add or remove a gem from the Gemfile.
- Version changes should happen in a separate PR. If a gem or ruby needs to be updated, leave a comment in the PR, and DO NOT CHANGE IT.
- Do not modify .bundle/config.

# Testing Instructions
Before you push a commit, you should verify your changes.
- Run `bundle exec rubocop -A` to autocorrect with rubocop.
- Run `bundle exec rspec` to run the tests - all should pass.


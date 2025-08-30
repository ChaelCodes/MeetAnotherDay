# frozen_string_literal: true

RailsCloudflareTurnstile.configure do |c|
  c.site_key = ENV.fetch("CLOUDFLARE_SITE_KEY", "")
  c.secret_key = ENV.fetch("CLOUDFLARE_SECRET_KEY", "")
  c.fail_open = true
  c.mock_enabled = !Rails.env.production? || ENV.fetch("IS_PULL_REQUEST") == "true"
end

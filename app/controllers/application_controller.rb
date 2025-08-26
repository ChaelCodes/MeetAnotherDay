# frozen_string_literal: true

# this is the base controller for my application, all controllers
# inherit from here
class ApplicationController < ActionController::Base
  # Ensure User is authorized to access route using Pundit
  include Pundit::Authorization
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from RailsCloudflareTurnstile::Forbidden, with: :handle_cloudflare_turnstile_failure
  after_action :verify_authorized, except: %i[index about], unless: :devise_controller?
  before_action :validate_cloudflare_turnstile, only: [:create], if: :devise_controller?

  protect_from_forgery with: :exception

  # rubocop:disable Rails/LexicallyScopedActionFilter
  # These methods are defined on many controllers and user should be
  # authenticated prior to using them.
  before_action :authenticate_user!, only: %i[create new update edit destroy]
  # rubocop:enable Rails/LexicallyScopedActionFilter

  # Add Pagination
  include Pagy::Backend

  # TODO: logged out users don't count notifications
  before_action :notification_count

  def current_profile
    current_user&.profile
  end

  private

  def notification_count
    @notification_count = policy_scope(Notification).count
  end

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end

  def handle_cloudflare_turnstile_failure
    flash[:alert] = "Uh oh! We need you to confirm you're not a bot in the cloudflare challenge."
    redirect_to cloudflare_failure_redirect_path
  end

  # rubocop:disable Metrics/MethodLength
  def cloudflare_failure_redirect_path
    case [params[:controller], params[:action]]
    when ["users/registrations", "create"]
      new_user_registration_path
    when ["devise/passwords", "create"]
      new_user_password_path
    when ["devise/confirmations", "create"]
      new_user_confirmation_path
    else
      log_unexpected_cloudflare_failure
      request.referrer || root_path
    end
  end
  # rubocop:enable Metrics/MethodLength

  def log_unexpected_cloudflare_failure
    Rails.logger.warn "Cloudflare turnstile failure from unexpected controller/action: " \
                      "#{params[:controller]}##{params[:action]}"
  end
end

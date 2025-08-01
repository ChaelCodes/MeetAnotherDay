# frozen_string_literal: true

module Users
  # Define redirect route after registration for devise
  class RegistrationsController < Devise::RegistrationsController
    protected

    def after_sign_up_path_for(_resource)
      new_profile_path
    end
  end
end

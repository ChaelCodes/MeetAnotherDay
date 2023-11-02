# frozen_string_literal: true

# Rules governing permissions for Notifications
class NotificationPolicy < ApplicationPolicy
  # Logged in users can create notifications
  def new?
    admin?
  end

  # Only the Notified Profile can view event details
  def show?
    return true if record.profile == current_profile
    record.profile.nil? && admin?
  end

  # Logged in users can create Notifications
  def create?
    user&.present?
  end

  # Only Admins can update Notifications
  def update?
    false
  end

  # The user Notified and Admins can destroy Notifications
  def destroy?
    current_profile == record.profile || user&.admin?
  end

  # Rules governing a list of Notifications
  class Scope < Scope
    def resolve
      return scope.where(profile: [current_profile, nil]) if admin?
      scope.where(profile: current_profile)
    end
  end
end

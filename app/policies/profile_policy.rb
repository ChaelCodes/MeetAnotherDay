# frozen_string_literal: true

# Control permissions for the Profile
class ProfilePolicy < ApplicationPolicy
  attr_reader :profile

  def initialize(user, record)
    super
    @profile = record
  end

  def index?
    confirmed_user?
  end

  # This method controls whether a user can view a profile.
  # Admins can always view profiles. Users can view their own profiles.
  # Profiles can set their own visibility.
  # * Everyone - anyone can view
  # * Authenticated - only logged in, and confirmed users can view
  # * Friends - only accepted friends can view
  # * Myself - only the user can view - NOT EVEN EXISTING FRIENDS!
  def show?
    return true if mine? || admin? || profile.visible_to_everyone?
    return confirmed_user? if profile.visible_to_authenticated?
    return current_profile&.friends_with? profile if profile.visible_to_friends?
  end

  def create?
    true
  end

  def update?
    mine?
  end

  def destroy?
    mine? || admin?
  end

  # Permissions and access for a collection of Users
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.all
    end
  end
end

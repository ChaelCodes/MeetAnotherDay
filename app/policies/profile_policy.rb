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

  # Whether the user can view the Profile's Handle, Bio, and Avatar.
  def show?
    return true if mine? || admin? || profile.visible_to_everyone?
    confirmed_user?
  end

  # This method controls whether a user can view a profile's details.
  # The details include the bio and event attendance.
  # Admins can always view profiles. Users can view their own profiles.
  # Profiles can set their own visibility.
  # * Everyone - anyone can view
  # * Authenticated - only logged in, and confirmed users can view
  # * Friends - only accepted friends can view
  # * Myself - only the user can view - NOT EVEN EXISTING FRIENDS!
  def show_details?
    return true if mine? || admin? || profile.visible_to_everyone?
    return confirmed_user? if profile.visible_to_authenticated?
    profile.friends_with? current_profile if profile.visible_to_friends?
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

  # Permissions and access for a collection of Profiles
  class Scope < Scope
    def resolve
      if profile
        profiles.nonblocked(profile).or(scope.befriended(profile)).or(scope.where(id: profile))
      else
        profiles
      end
    end

    private def profiles = confirmed? ? scope.with_authenticated : scope.visible_to_everyone
  end
end

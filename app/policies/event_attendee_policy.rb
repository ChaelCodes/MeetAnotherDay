# frozen_string_literal: true

# Rules governing permissions for Events
class EventAttendeePolicy < ApplicationPolicy
  attr_reader :profile

  def initialize(user, record)
    @profile = record.profile
    super
  end

  def show?
    ProfilePolicy.new(user, @profile).show_details?
  end

  # Allows users to see the index page, which currently only shows their records
  # but the scope will filter to only those they should see
  def index?
    true
  end

  def new?
    user.present?
  end

  def create?
    profile&.user == user
  end

  def update?
    profile.user == user || admin?
  end

  def destroy?
    profile.user == user
  end

  # Rules governing a list of EventAttendees
  class Scope < Scope
    def resolve
      scope.where(profile: ProfilePolicy::Scope.new(user, Profile).resolve)
    end
  end
end

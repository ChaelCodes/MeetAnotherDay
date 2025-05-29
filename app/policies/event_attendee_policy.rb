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
    false
  end

  def destroy?
    profile.user == user
  end

  # Rules governing a list of Events
  class Scope < Scope
    def resolve
      if user.nil?
        scope.none
      else
        # Permettre de voir les participations des amis
        scope.where(
          profile_id: user.profile.friendships.accepted.select(:friend_id)
        )
      end
    end
  end
end

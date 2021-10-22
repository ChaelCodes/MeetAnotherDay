# frozen_string_literal: true

# Rules governing permissions for Events
class EventAttendeePolicy < ApplicationPolicy
  attr_reader :profile

  def initialize(user, record)
    @profile = record.profile
    super
  end

  def show?
    true
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
    record.organizer
  end

  def destroy?
    profile.user == user
  end

  # Rules governing a list of Events
  class Scope < Scope
    def resolve
      scope.all
    end
  end
end

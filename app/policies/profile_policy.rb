# frozen_string_literal: true

# Control permissions for the Profile
class ProfilePolicy < ApplicationPolicy
  attr_reader :profile

  def initialize(user, record)
    super
    @profile = record
  end

  def index?
    true
  end

  def show?
    true
  end

  def create?
    true
  end

  def update?
    user && user.id == profile.user_id
  end

  def destroy?
    user && user.id == profile.user_id
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

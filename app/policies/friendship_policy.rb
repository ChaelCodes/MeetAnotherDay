# frozen_string_literal: true

# Control permissions for the FriendshipPolicy
class FriendshipPolicy < ApplicationPolicy
  attr_reader :friendship

  def initialize(user, record)
    super
    @friendship = record
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

  def edit?
    user.admin? && Rails.env.development?
  end

  def new?
    false
  end

  def update?
    return false unless user
    user.profile == friendship.buddy || user.profile == friendship.friend
  end

  def destroy?
    user.admin? || update?
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

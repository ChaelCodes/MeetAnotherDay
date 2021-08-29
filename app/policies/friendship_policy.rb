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

  def update?
    return false unless user
    user.profile == friendship.buddy || user.profile == friendship.friend
  end

  def destroy?
    return false unless user
    user.admin? || user.profile == friendship.buddy || user.profile == friendship.friend
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

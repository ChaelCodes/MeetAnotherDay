# frozen_string_literal: true

# Permissions and access for User
class UserPolicy < ApplicationPolicy
  def index?
    false
  end

  def show?
    user.id == record.id
  end

  def create?
    true
  end

  def update?
    user.id == record.id
  end

  def destroy?
    user.id == record.id
  end

  # Permissions and acess for a collection of Users
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

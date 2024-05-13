# frozen_string_literal: true

# Permissions and access for User
class UserPolicy < ApplicationPolicy
  def index?
    false
  end

  def show?
    user && user.id == record.id
  end

  def create?
    true
  end

  def update?
    user && user.id == record.id
  end

  def destroy?
    user && user.id == record.id
  end

  # Permissions and acess for a collection of Users
  class Scope < Scope
  end
end

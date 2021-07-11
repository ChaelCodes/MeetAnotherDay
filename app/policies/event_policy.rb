# frozen_string_literal: true

# Rules governing permissions for Events
class EventPolicy < ApplicationPolicy
  def show?
    true
  end

  def index?
    true
  end

  def create?
    user.present?
  end

  def update?
    user.present?
  end

  def destroy?
    user.present?
  end

  # Rules governing a list of Events
  class Scope < Scope
    def resolve
      scope.all
    end
  end
end

# frozen_string_literal: true

# Default access to all objects in the application.
class ApplicationPolicy
  attr_reader :current_profile, :record, :user

  def initialize(user, record)
    @user = user
    @current_profile = user&.profile
    @record = record
  end

  def index?
    true
  end

  def show?
    true
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  private

  def admin?
    user&.admin?
  end

  def confirmed_user?
    user&.confirmed?
  end

  def mine?
    record.try(:user) == user
  end

  # Default access scope for querying records.
  class Scope
    attr_reader :current_profile, :user, :scope

    def initialize(user, scope)
      @user = user
      @current_profile = user&.profile
      @scope = scope
    end

    def resolve
      scope.all
    end

    private

    def admin?
      user&.admin?
    end
  end
end

# frozen_string_literal: true

# Rules governing permissions for Events
class EventPolicy < ApplicationPolicy
  # Only Admins can new Events
  def new?
    user&.confirmed?
  end

  # Everyone can view Event details
  def show?
    true
  end

  # Everyone can view Event details
  def index?
    true
  end

  # Logged in users can create Events
  def create?
    user.present?
  end

  # Only Admins can update Events
  def update?
    event_attendee = EventAttendee.find_by(event_id: record&.id, profile_id: user&.profile&.id)
    user&.admin? or event_attendee&.organizer
  end

  # Only Admins can destroy Events
  def destroy?
    user&.admin?
  end

  # Rules governing a list of Events
  class Scope < Scope
  end
end

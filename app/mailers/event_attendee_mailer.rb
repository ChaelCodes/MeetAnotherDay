# frozen_string_literal: true

# Mailer responsible for email notifications around events to EventAttendees
class EventAttendeeMailer < ApplicationMailer
  helper EventsHelper

  def pre_event_email
    @event_attendee = params[:event_attendee]
    @event = @event_attendee.event
    @profile = @event_attendee.profile
    @user = @profile.user
    @friends_attending = friends_attending

    mail(
      to: @user.email,
      subject: "You are attending #{@event.name}!"
    )
  end

  private

  def friends_attending
    EventAttendeePolicy::Scope.new(
      @user,
      EventAttendee.friends_attending(event: @event, profile: @profile)
    ).resolve.includes(:profile)
  end
end

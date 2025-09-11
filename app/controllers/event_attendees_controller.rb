# frozen_string_literal: true

# Manages routing and instantiating variable for Event Attendees endpoints
class EventAttendeesController < ApplicationController
  before_action :authenticate_user!, only: %i[create update edit destroy]
  before_action :create_event_attendee, only: :create
  before_action :set_event_attendee, only: %i[show edit update destroy]

  # GET /event_attendees or /event_attendees.json
  def index
    event_attendees = if params[:event_id].present?
                        policy_scope(EventAttendee.where(event_id: params[:event_id]))
                      elsif current_user&.profile
                        EventAttendee.where(profile: current_user.profile)
                      else
                        EventAttendee.none
                      end

    @pagy, @event_attendees = pagy(event_attendees, page_param: :number)
    @pagination_links = pagy_jsonapi_links(@pagy, absolute: true)
  end

  # GET /event_attendees/1 or /event_attendees/1.json
  def show; end

  # GET /event_attendees/1/edit
  def edit; end

  # POST /event_attendees or /event_attendees.json
  def create
    respond_to do |format|
      if @event_attendee.save
        format.html { redirect_to @event_attendee, notice: "Event attendee was successfully created." }
        format.json { render :show, status: :created, location: @event_attendee }
      else
        format.html { redirect_to redirect_on_error_path, status: :unprocessable_content }
        format.json { render json: @event_attendee.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /event_attendees/1 or /event_attendees/1.json
  def update
    respond_to do |format|
      if @event_attendee.update(event_attendee_params)
        format.html { redirect_to @event_attendee, notice: "Event attendee was successfully updated." }
        format.json { render :show, status: :ok, location: @event_attendee }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @event_attendee.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /event_attendees/1 or /event_attendees/1.json
  def destroy
    @event_attendee.destroy
    respond_to do |format|
      format.html { redirect_to event_attendees_url, notice: "Event attendee was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # callback to set event attendee for create
  def create_event_attendee
    @event_attendee = EventAttendee.new(event_attendee_params)
    authorize @event_attendee
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_event_attendee
    @event_attendee = EventAttendee.find(params[:id])
    authorize @event_attendee
  end

  def redirect_on_error_path
    return event_path(@event_attendee.event) if @event_attendee.event
    return profile_path(@event_attendee.profile) if @event_attendee.profile
    root_path
  end

  # Only allow a list of trusted parameters through.
  def event_attendee_params
    params.require(:event_attendee).permit(:profile_id, :event_id, :email_scheduled_on, :organizer)
  end
end

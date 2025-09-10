# frozen_string_literal: true

# routes calls to the Events endpoint
class EventsController < ApplicationController
  before_action :create_event, only: :create
  before_action :set_event, only: %i[show edit update destroy]
  before_action :set_events, only: :index

  # GET /events or /events.json
  def index
    return unless current_profile
    @friends_attending_count = {}
    @events.each do |event|
      @friends_attending_count[event.id] = policy_scope(
        EventAttendee.friends_attending(event:, profile: current_profile)
      ).count
    end
  end

  # GET /events/1 or /events/1.json
  def show
    return unless current_profile
    @event_attendees = policy_scope(EventAttendee.friends_attending(event: @event, profile: current_profile))
    @event_attendee = current_user&.profile&.event_attendees&.find_by(event: @event)
  end

  # GET /events/new
  def new
    @event = Event.new
    authorize @event
  end

  # GET /events/1/edit
  def edit; end

  # POST /events or /events.json
  def create
    respond_to do |format|
      if @event.save
        EventAttendee.create!(profile_id: current_profile&.id, event_id: @event.id, organizer: true)
        format.html { redirect_to @event, notice: "Event was successfully created." }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @event.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /events/1 or /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: "Event was successfully updated." }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @event.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /events/1 or /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: "Event was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def current_profile
    @current_profile = current_user&.profile
  end

  # Callback for the create endpoint that instantiates and authorizes an event.
  def create_event
    @event = Event.new(event_params)
    authorize @event
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_event
    @event = Event.find_with_handle params[:id]
    @event ||= Event.find(params[:id])
    authorize @event
  end

  def set_events
    all_events = case params[:when]
                 when "future"
                   Event.future.order(:start_at)
                 when "past"
                   Event.past.order(start_at: :desc)
                 else
                   Event.ongoing.order(:start_at)
                 end
    @pagy, @events = pagy(all_events, page_param: :number)
    @pagination_links = pagy_jsonapi_links(@pagy, absolute: true)
  end

  # Only allow a list of trusted parameters through.
  def event_params
    params.require(:event).permit(:name, :handle, :description, :start_at, :end_at)
  end
end

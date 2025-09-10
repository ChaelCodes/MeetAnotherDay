# frozen_string_literal: true

# Responsible for handling requests to the notifications endpoint
class NotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_notification, only: %i[show destroy]
  before_action :create_notification, only: :create

  # GET /notifications or /notifications.json
  def index
    @notifications = policy_scope(Notification)
  end

  # GET /notifications/1 or /notifications/1.json
  def show; end

  # GET /notifications/new
  def new
    @notification = Notification.new
    authorize @notification
  end

  # POST /notifications or /notifications.json
  def create
    respond_to do |format|
      if @notification.save
        format.html { redirect_to @notification, notice: "Notification was successfully created." }
        format.json { render :show, status: :created, location: @notification }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @notification.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /notifications/1 or /notifications/1.json
  def destroy
    @notification.destroy
    respond_to do |format|
      format.html { redirect_to notifications_url, notice: "Notification was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def create_notification
    @notification = Notification.new(notification_params)
    authorize @notification
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_notification
    @notification = Notification.find(params[:id])
    authorize @notification
  end

  # Only allow a list of trusted parameters through.
  def notification_params
    params.require(:notification).permit(:message, :notifiable_id, :notifiable_type, :profile_id, :url)
  end
end

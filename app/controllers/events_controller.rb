class EventsController < ApplicationController
  before_action :set_user
  before_action :set_user_event, only: [:show, :update, :destroy]

  # GET /users/:user_id/events
  def index
    json_response(@user.events)
  end

  # GET /users/:user_id/events/:id
  def show
    json_response(@event)
  end

  # POST /users/:user_id/events
  def create
    @user.events.create!(event_params)
    json_response(@user, :created)
  end

  # PUT /users/:user_id/events/:id
  def update
    @event.update(event_params)
    head :no_content
  end

  # DELETE /users/:user_id/events/:id
  def destroy
    @event.update(deleted_at: Time.now)
    head :no_content
  end

  private

  def event_params
    params.permit(:name, :duration, :location, :start_at, :end_at, :duration, :description, :deleted_at)
  end

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_user_event
    @event = @user.events.find_by!(id: params[:id]) if @user
  end
end

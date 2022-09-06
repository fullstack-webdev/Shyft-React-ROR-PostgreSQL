class Api::EventsController < ApplicationController
  before_action :authenticate_agency!
   # before_action :require_login, only: [:edit]

  def index
    @agency_id = current_agency.id
    @event = Event.find(session[:event_id])
    render json: @event ,status: 200  
  end

  def show
      render :show
  end

  def new
    #
    # if session[:event_id]
    #   # based on the event_id and the shifts tied to it
    #   @ambassadors = Ambassador.includes(:weekly_unavailability)
    #   @event = Event.find(session[:event_id])#Event.find(7)
    # else
    #   @event = Event.new
    #     @agency = current_agency
    #
    #   @event.name = 'New Event'
    #   @event.event_details = 'Describe your event here'
    #   @event.agency_id = @agency.id
    #
    #   if @event.save
    #       session[:event_id] = @event.id
    #   end
    # end
  end

  def create
      
    @event = Event.new(event_params)
    if @event.save
          #
          render json: {
      name: params[:event][:name],
      event_details: params[:event][:event_details],
              id: @event.id,
              agency_id: @event.agency_id,
              event_locations: @event.event_locations
    }
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  def show
    @event = Event.find(params[:id])
    @ambassadors = Ambassador.all
    # @author = User.find(@article.user_id).first_name
    # @city = City.find(@article.city_id).name
    # @comments = @article.comments
    # render :show
  end

  def edit
    @event = Event.find(params[:id])
    # if @event.user_id == current_user.id
    #     render :edit
    # else
    #     redirect_to root_path
    # end
  end

  def update
    #
    @event = Event.find(params[:id])
    if @event.update(event_params)
          render json: @event
      else
          render json: @event.errors, status: :unprocessable_entity
      end

    # if @event.update(event_params)
    #    redirect_to event_path(@event)
    # else
    #   render :edit    ### potentially cityhange render page???? ###
    # end
  end

  def destroy
    @location = EventLocation.find_by_id(params[:id])
    if @location.destroy
      render json: {id: params[:id]}, status: 200
    else
      render json: @location.errors, status: :unprocessable_entity
    end
  end
  private

    def event_params
      params.require(:event).permit(:agency_id, :name, :event_details, :current_location_id, event_locations_attributes: [:id, :label, :address, :zip, :state, :country, :notes, event_dates_attributes: [:id, :event_date, :start_time, :end_time, event_roles_attributes: [:id, :role, :hourly_rate, :quantity]]])
    end

end

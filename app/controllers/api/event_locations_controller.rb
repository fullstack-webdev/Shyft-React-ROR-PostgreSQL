class Api::EventLocationsController < ApplicationController
  def new

  end

  def index
    @event_id = params[:event_id]
    if @event_id.present?
      @locations = EventLocation.where(event_id: @event_id)
    else  
      @locations = EventLocation.all
    end
    render json: @locations, status: 200  
  end

  def create
    @location = EventLocation.new(location_params)
    if @location.save
			render json: @location
    else
    	render json: @location.errors, status: :unprocessable_entity
    end
  end

  def update
		@location = EventLocation.find(params[:id])
    if @location.update(location_params)
			render json: @location
		else
			render json: @location.errors, status: :unprocessable_entity
		end
  end

  def destroy
    # NOTE: required params[:id]
    @location = EventLocation.find(params[:id])
    if @location.destroy
      render json: {id: params[:id]}, status: 200
    else
      render json: @location.errors, status: :unprocessable_entity
    end
  end

  private
  def location_params
    params.require(:location).permit(:id, :label, :address, :zip, :state, :country, :notes, :city, :city_id, :event_id)
  end
end

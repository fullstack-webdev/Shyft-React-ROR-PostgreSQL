class EventLocationsController < ApplicationController
  def new

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
    value = @location.update(location_params)
    p value
    if value
			render json: @location
		else
			render json: @location.errors, status: :unprocessable_entity
		end
  end

  private
  def location_params
    params.require(:location).permit( :label, :address, :zip, :state, :country, :notes, :city, :event_id)
  end
end

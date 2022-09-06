class Api::EventDatesController < ApplicationController
	before_action :authenticate_agency!

  def new
    @event_date = EventDate.new
  end

	def index
		if @event_dates = EventDate.where(event_location_id:params[:event_location_id])
      @sorted_event_dates = @event_dates.sort_by &:event_date
      render json: @sorted_event_dates
    else
      render json: @event_dates.errors, status: :unprocessable_entity
    end
	end

  def create
    @event_date = EventDate.new(event_date_params)
    if @event_date.save
			render json: @event_date
    else
    	render json: @event_date.errors, status: :unprocessable_entity
    end
  end

  def update
		@event_date = EventDate.find(params[:id])
    if @event_date.update(event_date_params)
			render json: @event_date
		else
			render json: @event_date.errors, status: :unprocessable_entity
		end
  end

  def destroy
    @event_date = EventDate.find_by_id(params[:id])
    if @event_date.destroy
      render json: {id: params[:id]}, status: 200
    else
			render json: @event_date.errors, status: :unprocessable_entity
		end
  end

  def datesByLocation
    if @event_dates = EventDate.where(event_location_id:params[:event_location_id])
      @sorted_event_dates = @event_dates.sort_by &:event_date
      render json: @sorted_event_dates
    else
      render json: @event_dates.errors, status: :unprocessable_entity
    end
  end

  def addShift
    @event_date_shift = EventDateShift.new(event_date_shift_params)
    if @event_date_shift.save
      render json: @event_date_shift
    else
      render json: @event_date_shift.errors, status: :unprocessable_entity
    end
  end

  def shiftsByDateId
    if @event_date_shifts = EventDateShift.where(event_date_id:params[:event_date_id])
      @sorted_shifts = @event_date_shifts.sort_by &:start_time
      render json: @sorted_shifts
    else
      render json: @event_date_shifts.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @event_date = EventDate.find(params[:id])
    if @event_date.destroy
      render json: {id: params[:id]}, status: 200
    else
      render json: @event_date.errors, status: :unprocessable_entity
    end
  end

  private
  def event_date_params
    params.require(:event_date).permit(:id, :event_date, :event_location_id)
  end

  def event_date_shift_params
    params.require(:event_date_shift).permit(:id, :start_time, :end_time, :event_date_id)
  end
end

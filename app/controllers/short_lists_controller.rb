# FUTURE HOME OF ALL SHORT LIST API METHODS
class ShortListsController < ApplicationController

# returns the end point to the booking summary
  def submit
    event_id = params[:event_id]
    existing_booking = Booking.find_by(event_id: event_id)
    if existing_booking.nil?
      render json: { next_url: new_booking_url + "?event_id=" + event_id}, status:200
    else
	    render json: { next_url: edit_booking_url(existing_booking.id) }, status:200
    end
  end
end

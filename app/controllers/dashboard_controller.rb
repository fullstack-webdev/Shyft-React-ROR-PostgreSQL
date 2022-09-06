class DashboardController < ApplicationController
	before_action :logged_in_ambassador,  only: [:edit, :update]
  before_action :correct_user,          only: [:edit, :update]
  helper_method :ambassador_conversation

  #get all events confirmed by ambassador...
  def index
  	if logged_in?
      #for current events we're not checking status
      current_event_ids = EventRole.joins('join event_dates ON event_roles.event_date_id=event_dates.id').where('role_status =? and ambassador_id=? and event_date >=  NOW()::date',STATUS_CONFIRMED, current_user.id).pluck(:event_id)
      #for past events we only check confiremd events
	  	past_event_ids =  EventRole.joins('join event_dates ON event_roles.event_date_id=event_dates.id').where('role_status=? and ambassador_id=? and event_date < NOW()::date',STATUS_CONFIRMED, current_user.id).pluck(:event_id)
	  	@current_events = Event.where(id: current_event_ids)
      @past_events = Event.where(id: past_event_ids)
	  else
	  	@current_events = nil
      @past_events = nil
	  end
    render :index
  end


  def cancel_booking
    event = Event.find(params[:event_id])
    ambassador = Ambassador.find(params[:ambassador_id])

    pending_roles = EventRole.where('event_id = ? AND ambassador_id = ? AND role_status = ?', event.id, ambassador.id, STATUS_PENDING)

    #cancel all pending bookings
    booking_staff_items = BookingStaffItem.where(event_role_id: pending_roles.pluck(:id))
    booking_staffs = BookingStaff.where(id: booking_staff_items.pluck(:booking_staff_id))
    bookings = Booking.where(id: booking_staffs.pluck(:booking_id))
    
    booking_staff_items.update_all(status: STATUS_CANCELLED)
    booking_staffs.update_all(confirm_token: nil)
    pending_roles.update_all(role_status: STATUS_EMPTY)
    #cancel all confirmed but not started bookings
    confirmed_roles = EventRole.joins('JOIN event_dates ON event_roles.event_date_id = event_dates.id').where('event_id = ? AND ambassador_id = ? AND role_status = ? and event_dates.event_date >= NOW()::date', event.id, ambassador.id, STATUS_CONFIRMED)


    booking_staff_items = BookingStaffItem.where(event_role_id: confirmed_roles.pluck(:id))
    booking_staffs = BookingStaff.where(id: booking_staff_items.pluck(:booking_staff_id))
    bookings = Booking.where(id: booking_staffs.pluck(:booking_id))
    agency =  event.agency #Agency.where(id: bookings.pluck(:agency_id)).first


    booking_staff_items.update_all(status: STATUS_CANCELLED)
    booking_staffs.update_all(confirm_token: nil)
    confirmed_roles.update_all(role_status: STATUS_EMPTY)

    #cancel all short list bookings
    short_listed_roles = EventRole.where('event_id = ? AND ambassador_id = ? AND role_status = ?', event.id, ambassador.id, STATUS_SHORT_LIST)

    booking_staff_items = BookingStaffItem.where(event_role_id: short_listed_roles.pluck(:id))
    booking_staffs = BookingStaff.where(id: booking_staff_items.pluck(:booking_staff_id))
    bookings = Booking.where(id: booking_staffs.pluck(:booking_id))

    booking_staff_items.update_all(status: STATUS_CANCELLED)
    booking_staffs.update_all(confirm_token: nil)
    short_listed_roles.update_all(role_status: STATUS_EMPTY)

    # notify globally via email
    BookingMailer.send_email_booking_cancelled_notification(event ,ambassador, agency).deliver_now
    
    # notify agency via email
    BookingMailer.send_email_booking_cancelled_agency(event ,ambassador, agency).deliver_now
    #now redirect to index
    if agency
      flash[:cancel_booking] = "Your booking has been cancelled! A message has been sent to the #{agency.display_name} to notify them."
    else
      flash[:cancel_booking] = "NO Agency found"
    end  
    
    redirect_to action: 'index'
  end

end

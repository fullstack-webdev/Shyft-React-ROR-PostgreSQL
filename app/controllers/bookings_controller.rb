class BookingsController < ApplicationController

  def new
    event_id = params[:event_id]

    self.build_booking(false, event_id)
  end

  def create
    # given the params event_id
    # we are going to recreate booking models and save them
    event_id = params[:booking][:event_id]
    self.build_booking(true, event_id)

    if @booking.save
      @booking.booking_staff.each do |staff|
        staff.send_email_booking_request
      end

      redirect_to events_url, :flash => {:success => "All requests have been sent, Ambassadors will have two hours to confirm your booking request."}
    else
      flash.now[:danger] = 'Unable to send booking request, please try again'
      render 'new', event_id
    end
  end

  def edit
    # event = Event.find_by_id(params[:event_id])
    @booking = Booking.find_by_id(params[:id])
    @event = @booking.event
    @booking_summary = @booking.booking_summary
    new_roles = EventRole.where('event_id = ? AND ambassador_id > 0 AND role_status = ?', @event.id, STATUS_SHORT_LIST)
    current_roles = EventRole.where('event_id = ? AND ambassador_id > 0 AND (role_status = ? OR role_status = ?)', @event.id, STATUS_PENDING, STATUS_CONFIRMED)

    staff = {}
    pendingStatus = STATUS_PENDING
    roles = {}

    @booking_sub_total = BigDecimal.new(0)
    @unique_staff = 0
    @new_staff = []

    new_roles.each do |role|
      current_booking = staff[role.ambassador_id]

      if !current_booking
        current_booking = BookingStaff.new
        current_booking.ambassador_id = role.ambassador_id
        current_booking.booking_id = @booking.id
        current_booking.booking_staff_items.build(event_role_id: role.id)
        staff[role.ambassador_id] = current_booking
        @new_staff.push(current_booking)
      else
        current_booking.booking_staff_items.build(event_role_id: role.id)
      end

      @booking_sub_total += role.cost
      roles[role.id] = {"role_status"=> pendingStatus}
    end

    @unique_staff += staff.values.length
    @staff_bookings = staff.values

    current_roles.each do |role|
      if !staff[role.ambassador_id]
        staff[role.ambassador_id] = {}
        @unique_staff += 1
      end

      @booking_sub_total += role.cost
    end

    # @booking_tax_total = (@booking_sub_total * @booking_summary.tax_rate)
    @booking_service_fee_total = (@booking_sub_total * @booking_summary.service_fee_rate)
    @booking_total = @booking_sub_total + @booking_service_fee_total
  end


  # differentiate between short listed or pending / accepted roles
  def update
    @booking = Booking.find_by_id(params[:id])
    @booking_summary = @booking.booking_summary
    new_roles = EventRole.where('event_id = ? AND ambassador_id > 0 AND role_status = ?', @booking.event_id, RoleStatus.short_list)

    event_roles = {}
    staff = {}

    pendingStatus = STATUS_PENDING
    new_staff = []

    new_roles.each do |role|
      current_booking = staff[role.ambassador_id]

      if !current_booking
        current_booking = @booking.booking_staff.build(ambassador_id: role.ambassador_id, booking_id:@booking.id)
        current_booking.booking_staff_items.build(event_role_id: role.id)
        staff[role.ambassador_id] = current_booking
        new_staff.push(current_booking)
      else
        current_booking.booking_staff_items.build(event_role_id: role.id)
      end

      event_roles[role.id] = {"role_status"=> pendingStatus}
    end

    EventRole.update(event_roles.keys, event_roles.values)
    new_staff.each do |staff|
      staff.save
      staff.send_email_booking_request
    end

    redirect_to events_url, :flash => {:success => "All requests have been sent, Ambassadors will have two hours to confirm your booking request."}
  end

  def build_booking(save, event_id)
    @event = Event.find(event_id)
    @booking = Booking.new
    @booking.event_id = event_id
    @booking.agency_id = @event.agency_id
    @booking_summary = @booking.build_booking_summary

    staff = {}
    pendingStatus = STATUS_PENDING
    roles = {}

    # NOTE better query here to include ambassadors and decrease load on server
    event_roles = EventRole.where('event_id = ? AND ambassador_id > 0', event_id)
    @booking_sub_total = BigDecimal.new(0)

    event_roles.each do |role|
      # ambassador = Ambassador.find(role.ambassador_id)
      current_booking = staff[role.ambassador_id]

      if !current_booking
        current_booking = @booking.booking_staff.build(ambassador_id: role.ambassador_id)
        current_booking.booking_staff_items.build(event_role_id: role.id)
        staff[role.ambassador_id] = current_booking
      else
        current_booking.booking_staff_items.build(event_role_id: role.id)
      end

      @booking_sub_total += role.cost
      roles[role.id] = {"role_status"=> pendingStatus}
    end

    @staff_bookings = staff.values
    @booking_summary.unique_staff = @staff_bookings.length
    @booking_summary.tax_rate = BigDecimal.new("0.15")
    @booking_summary.service_fee_rate = BigDecimal.new("0.15")
    # @booking_tax_total = (@booking_sub_total * @booking_summary.tax_rate)
    @booking_service_fee_total = (@booking_sub_total * @booking_summary.service_fee_rate)
    @booking_total = @booking_sub_total + @booking_service_fee_total

    if save
      EventRole.update(roles.keys, roles.values)
    end

    return @booking
  end

  #params => booking_staff_id
  # WE ARE GOING TO HAVE TO ENCRYPT THE LINK PROVIDED FOR THE EMAILS
  def book_request_accept_confirm
    booking_staff =  BookingStaff.find_by_confirm_token(params[:id])

    if booking_staff
      staff_id = booking_staff.id
      confirmed_status = STATUS_CONFIRMED

      if self.book_request_response(staff_id, confirmed_status)

        #Start communication between agency and ambassador
        #agency sends thank you message to ambassador
        agency_id = booking_staff.booking.agency_id
        event_id = booking_staff.booking.event_id
        new_conversation = Conversation.create!(sender_id: agency_id, recipient_id: booking_staff.ambassador_id, event_id: event_id)
        Message.create!(content:"Thanks for accepting booking request!", user_id: agency_id, user_type: "agency", conversation_id: new_conversation.id)

        # NOTE - WE SHOULD REDIRECT HERE TO THE BOOKING CONFIRMED PAGE ?
        booking_staff.send_email_booking_accepted
        booking_staff.update(:confirm_token => nil)

        render 'request_accept_confirm'
        return
      end
    end

    # NOTE - IF FOR WHATEVER REASON GETTING THE BookingStaff MODEL FAILS
    # WE SHOULD TELL THE USER TO TRY AGAIN ?
  end

  # NOTE - => booking_staff_id
  # WE ARE GOING TO HAVE TO ENCRYPT THE LINK PROVIDED FOR THE EMAILS
  def book_request_decline_confirm
    booking_staff =  BookingStaff.find_by_confirm_token(params[:id])

    if booking_staff
      staff_id = booking_staff.id
      declined_status = STATUS_DECLINED

      if self.book_request_response(staff_id, declined_status)
        booking_staff.send_email_booking_declined
        booking_staff.update(:confirm_token => nil)
        render 'request_decline_confirm'
        return
      end
    end

    # NOTE - IF FOR WHATEVER REASON GETTING THE BookingStaff MODEL FAILS
    # WE SHOULD TELL THE USER TO TRY AGAIN ?
  end

  def book_request_response(staff_id, status)
    if @booking_staff = BookingStaff.find_by_id(staff_id)
      return @booking_staff.update_role_status(status)
    end

    return false
  end
end

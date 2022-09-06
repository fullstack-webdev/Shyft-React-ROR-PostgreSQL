class BookingMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.ambassador_mailer.account_activation.subject
  #
  def load_variables(booking_staff)
    @ambassador = Ambassador.find_by_id(booking_staff.ambassador_id)
    @item = booking_staff.booking_staff_items[0]
    @event = booking_staff.booking.event
    @agency = @event.agency
    #@eventRole = EventRole.find_by_id(@item.event_role_id)
    #@eventLocation = @event.event_locations[0]
    @request_token = booking_staff.confirm_token #SecureRandom.urlsafe_base64(32).to_s

    @schedules = []
    @subtotal_earnings = BigDecimal.new(0)
    @ambassador_service_fee = BigDecimal.new("0.1")
    @ambassador_service_fee_total = BigDecimal.new(0)
    @total_net_earnings = BigDecimal.new(0)
    @role_rates = {}
    total = BigDecimal.new(0)

    booking_staff.booking_staff_items.each do |item|
      eventRole = EventRole.find(item.event_role_id)
      if @role_rates[eventRole.hourly_rate]
        total = @role_rates[eventRole.hourly_rate] + eventRole.total_hours
        @role_rates[eventRole.hourly_rate] = total
      else
        @role_rates[eventRole.hourly_rate] = eventRole.total_hours
      end

      @subtotal_earnings += eventRole.cost
      event_date_shift = eventRole.event_date_shift
      event_date = event_date_shift.event_date
      location = event_date.event_location
      @schedules.push({
          date: event_date.event_date.strftime('%A, %B %d, %Y'),
          startTime: event_date_shift.start_time.strftime('%I:%M %p'),
          endTime: event_date_shift.end_time.strftime('%I:%M %p'),
          location: location.display_address(),
          notes: location.notes
        })
    end

    @ambassador_service_fee_total = @subtotal_earnings * @ambassador_service_fee
    @total_earnings = @subtotal_earnings - @ambassador_service_fee_total

    # booking_staff.confirm_token(@request_token)
    # TODO: we need to set respose by time
    # TODO: Kyle has trello card associated with handling request and response times
    load_image_assets
  end

  def load_image_assets
    @avatar_image = @ambassador.images[0]
    @avatar_image_url = nil
    if @avatar_image.present?
      attachments.inline['avatar.png'] = nil
      @avatar_image_url = 'https://www.shyftworks.com' + Refile.file_url(@avatar_image.file, filename: 'profile')
      p @avatar_image_url
    else
      attachments.inline['avatar.png'] = File.read(Rails.root.join('app/assets/images/shyft-d-profile.png'))
    end

    attachments.inline['logo.png'] = File.read(Rails.root.join('app/assets/images/shyft-logo-main.png'))
    attachments.inline['stars.png'] = File.read(Rails.root.join('app/assets/images/stars.png'))
  end

  def send_email_booking_request(booking_staff)
    # NOTE -
    load_variables booking_staff
    @expire_time = (Time.now + 2.hours).strftime('%A, %B %d, %Y, %I:%M %p')
    # SINCE WE DO NOT HAVE A STAGING ENV WE ARE SENDING ALL EMAILS TO OURSELVES FOR THE TIME BEING
    # mail to: @ambassador.email, subject: 'New Booking Request'
    mail to: @ambassador.email, bcc: 'bookings@shyftworks.com', reply_to: 'bookings@shyftworks.com', subject: 'New Booking Request'
  end


  def send_email_booking_accepted(booking_staff)
    # NOTE -
    load_variables booking_staff
    # SINCE WE DO NOT HAVE A STAGING ENV WE ARE SENDING ALL EMAILS TO OURSELVES FOR THE TIME BEING
    # mail to: @ambassador.email, subject: 'Accepted Booking Request'
    mail to: @ambassador.email, bcc: 'bookings@shyftworks.com', reply_to: 'bookings@shyftworks.com', subject: 'Booking Request Accepted'
  end

  def send_email_booking_expired(booking_staff)
    # NOTE -
    load_variables booking_staff
    # SINCE WE DO NOT HAVE A STAGING ENV WE ARE SENDING ALL EMAILS TO OURSELVES FOR THE TIME BEING
    # mail to: @ambassador.email, subject: 'Expired Booking Request'
    mail to: @ambassador.email, bcc: 'bookings@shyftworks.com', reply_to: 'bookings@shyftworks.com', subject: 'Booking Request Expired'
  end

  def send_email_booking_cancelled_notification(event, ambassador, agency)
    # SINCE WE DO NOT HAVE A STAGING ENV WE ARE SENDING ALL EMAILS TO OURSELVES FOR THE TIME BEING
    # mail to: @ambassador.email, subject: 'Expired Booking Request'
    @event = event
    @ambassador = ambassador
    @agency = agency
    load_image_assets
    mail to: "bookings@shyftworks.com", subject: "Booking Cancelled #{@ambassador.full_name} for #{@event.name}"
  end

  def send_email_booking_cancelled_agency(event , ambassador, agency)
    # NOTE -
    @event = event
    @ambassador = ambassador
    @agency = agency
    load_image_assets
    # SINCE WE DO NOT HAVE A STAGING ENV WE ARE SENDING ALL EMAILS TO OURSELVES FOR THE TIME BEING
    # mail to: @ambassador.email, subject: 'Expired Booking Request'
    mail to: "bookings@shyftworks.com", subject: "Booking Cancelled #{@ambassador.full_name} for #{@event.name}"
  end

  def send_email_booking_declined(booking_staff)
    # NOTE -
    load_variables booking_staff
    # SINCE WE DO NOT HAVE A STAGING ENV WE ARE SENDING ALL EMAILS TO OURSELVES FOR THE TIME BEING
    # mail to: @ambassador.email, subject: 'Declined Booking Request'
    mail to: @ambassador.email, bcc: 'bookings@shyftworks.com', reply_to: 'bookings@shyftworks.com', subject: 'Booking Request Declined'
  end
end

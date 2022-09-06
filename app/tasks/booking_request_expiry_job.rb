BookingRequestExpiryJob = Struct.new(:booking_staff_id) do
  def perform
    staff_item = BookingStaff.find_by_id(self.booking_staff_id)
    BookingMailer.send_email_booking_expired(staff_item).deliver_now
    staff_item.update_role_status(STATUS_EXPIRED)
  end

  def display_name
    return "booking_expiry_job-#{booking_staff_id}"
  end
end

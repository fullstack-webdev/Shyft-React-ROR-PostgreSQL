# NOTE - Model that has relationship between ambassador and booking

class BookingStaff < ActiveRecord::Base
  before_create :confirmation_token
  belongs_to :booking
  has_many :booking_staff_items, dependent: :destroy

  def total_cost
    total_cost = 0
    self.booking_staff_items.each do |item|
      total_cost += item.total_cost
    end
    return total_cost
  end

  def total_hours
    total_hours = 0
    self.booking_staff_items.each do |item|
      total_hours += item.total_hours
    end

    return total_hours
  end

  def pending
    @pending = self.booking_staff_items.where('status = ?', STATUS_PENDING)
  end

  def confirmed
    @confirmed = self.booking_staff_items.where('status = ?', STATUS_CONFIRMED)
  end

  def ambassador_name
    self.ambassador.full_name
  end

  def send_email_booking_request
    BookingMailer.send_email_booking_request(self).deliver_now
    booking_job = BookingRequestExpiryJob.new(self.id)
    job = Delayed::Job.enqueue booking_job, :queue => "booking/expiry", :priority => 0, :run_at => 2.hours.from_now
    update_attribute(:delayed_job_id, job.id)
  end

  def send_email_booking_accepted
    BookingMailer.send_email_booking_accepted(self).deliver_now
    cancel_expiry
  end

  def send_email_booking_declined
    BookingMailer.send_email_booking_declined(self).deliver_now
    cancel_expiry
  end

  def send_email_booking_expired
    BookingMailer.send_email_booking_expired(self).deliver_now
    self.update_role_status(STATUS_EXPIRED)
  end

  def cancel_expiry
    booking_job = Delayed::Job.find(self.delayed_job_id)
    if booking_job
      booking_job.delete
    end
  end

  # NOTE - When an ambassador has either accepted or declined the booking
  # We need to update the EventRole.role_status with either confirmed or declined
  def update_role_status(status)
    roles_to_update = {}
    role_ids = self.booking_staff_items.pluck('event_role_id')
    self.update_booking_staff_items_status(status)
    EventRole.where(id: role_ids).each do |role|
      if status == STATUS_DECLINED || status == STATUS_EXPIRED
        roles_to_update[role.id] = {"role_status" => STATUS_EMPTY, "ambassador_id" => nil}
      else
        roles_to_update[role.id] = {"role_status" => status}
      end
    end

    return EventRole.update(roles_to_update.keys, roles_to_update.values)
  end

  def update_booking_staff_items_status(status)
    self.booking_staff_items.each do |item|
      item.status = status
      item.save
    end
  end

  def ambassador
    if @ambassador
      return @ambassador
    elsif !self.ambassador_id.nil?
      return @ambassador = Ambassador.find_by_id(self.ambassador_id)
    else
      return nil
    end
  end

  private

  def new_confirmation_token(new_token)

  end

  def confirmation_token
    if self.confirm_token.blank?
      self.confirm_token = SecureRandom.urlsafe_base64.to_s
    end
  end
end

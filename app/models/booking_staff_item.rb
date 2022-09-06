# NOTE - Model that has relationship with all EventRole
# For each unique EventRole there is a new BookingStaffItem

class BookingStaffItem < ActiveRecord::Base
  belongs_to :booking_staff

  def total_cost
    EventRole.find(event_role_id).cost
  end

  def total_hours
    EventRole.find(event_role_id).total_hours
  end
end

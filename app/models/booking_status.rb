# NOTE - Used for tracking the payment status of a Booking
class BookingStatus < ActiveRecord::Base
  belongs_to :booking
end

class Booking < ActiveRecord::Base
  has_many :booking_transactions, dependent: :destroy
  has_one :booking_summary, dependent: :destroy
  belongs_to :agency
  # don't yet have booking status set up.
  # not sure if I want this to track the status of the entire booking_status
  # or the booking staff
  # has_one :booking_status, dependent: :destroy
  has_many :booking_staff, dependent: :destroy

  belongs_to :event
end

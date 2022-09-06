# NOTE - A single payment transaction made by Agency
class BookingTransaction < ActiveRecord::Base
  belongs_to :booking
end

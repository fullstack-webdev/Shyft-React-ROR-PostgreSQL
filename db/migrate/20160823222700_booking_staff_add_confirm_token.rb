class BookingStaffAddConfirmToken < ActiveRecord::Migration
  def change
  	add_column :booking_staffs, :confirm_token, :string
  end
end

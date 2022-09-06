class AddStatusToBookingStaffItem < ActiveRecord::Migration
  def change
    add_column :booking_staff_items, :status, :string, :default => "pending"
  end
end

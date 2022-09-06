class CreateBookingStaffs < ActiveRecord::Migration
  def change
    create_table :booking_staffs do |t|
      t.belongs_to :booking, index: true
      t.references :ambassador, index: true

      t.timestamps null: false
    end
    add_foreign_key :booking_staffs, :bookings
    add_foreign_key :booking_staffs, :ambassadors
  end
end

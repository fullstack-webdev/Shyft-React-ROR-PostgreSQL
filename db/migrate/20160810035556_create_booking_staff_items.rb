class CreateBookingStaffItems < ActiveRecord::Migration
  def change
    create_table :booking_staff_items do |t|
      t.belongs_to :booking_staff, index: true
      t.references :event_role, index: true

      t.timestamps null: false
    end

    add_foreign_key :booking_staff_items, :booking_staffs
    add_foreign_key :booking_staff_items, :event_roles
  end
end

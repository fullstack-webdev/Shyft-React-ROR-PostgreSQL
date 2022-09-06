class CreateBookingStatuses < ActiveRecord::Migration
  def change
    create_table :booking_statuses do |t|
      t.integer :type_id

      t.timestamps null: false
    end
  end
end

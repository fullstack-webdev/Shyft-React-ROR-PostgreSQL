class CreateBookingStatusTypes < ActiveRecord::Migration
  def change
    create_table :booking_status_types do |t|
      t.string :status

      t.timestamps null: false
    end
  end
end

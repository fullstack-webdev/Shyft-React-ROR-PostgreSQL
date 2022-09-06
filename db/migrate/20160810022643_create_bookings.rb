class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.belongs_to :agency, index: true
      t.belongs_to :event, index: true

      t.timestamps null: false
    end

    add_foreign_key :bookings, :agencies
    add_foreign_key :bookings, :events
  end
end

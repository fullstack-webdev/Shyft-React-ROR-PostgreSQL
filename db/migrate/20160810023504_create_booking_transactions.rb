class CreateBookingTransactions < ActiveRecord::Migration
  def change
    create_table :booking_transactions do |t|
      t.belongs_to :booking
      t.decimal :amount

      t.timestamps null: false
    end

    add_foreign_key :booking_transactions, :bookings
  end
end

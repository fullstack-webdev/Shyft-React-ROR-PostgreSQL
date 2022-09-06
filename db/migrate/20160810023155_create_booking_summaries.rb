class CreateBookingSummaries < ActiveRecord::Migration
  def change
    create_table :booking_summaries do |t|
      t.belongs_to :booking, index: true
      t.integer :unique_staff
      t.decimal :service_fee_rate
      t.decimal :tax_rate

      t.timestamps null: false
    end

    add_foreign_key :booking_summaries, :bookings
  end
end

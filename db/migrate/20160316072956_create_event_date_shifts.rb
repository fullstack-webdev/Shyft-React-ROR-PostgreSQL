class CreateEventDateShifts < ActiveRecord::Migration
  def change
    create_table :event_date_shifts do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.integer :event_date_id

      t.timestamps null: false
    end
  end
end

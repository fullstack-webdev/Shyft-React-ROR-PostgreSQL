class CreateEventDates < ActiveRecord::Migration
  def change
    create_table :event_dates do |t|
      t.date :event_date
      t.time :start_time
      t.time :end_time

      t.timestamps null: false
    end
  end
end

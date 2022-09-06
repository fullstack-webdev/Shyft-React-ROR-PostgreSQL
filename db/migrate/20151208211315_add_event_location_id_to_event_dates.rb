class AddEventLocationIdToEventDates < ActiveRecord::Migration
  def change
    add_column :event_dates, :event_location_id, :integer
  end
end

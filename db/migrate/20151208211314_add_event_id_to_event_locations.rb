class AddEventIdToEventLocations < ActiveRecord::Migration
  def change
    add_column :event_locations, :event_id, :integer
  end
end

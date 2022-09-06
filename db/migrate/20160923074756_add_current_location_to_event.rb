class AddCurrentLocationToEvent < ActiveRecord::Migration
  def change
  	add_column :events, :current_location_id, :integer
  end
end

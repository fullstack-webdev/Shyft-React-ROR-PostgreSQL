class CreateEventLocations < ActiveRecord::Migration
  def change
    create_table :event_locations do |t|
      t.string :label
      t.string :address
      t.string :zip
      t.string :state
      t.string :country
      t.string :notes

      t.timestamps null: false
    end
  end
end

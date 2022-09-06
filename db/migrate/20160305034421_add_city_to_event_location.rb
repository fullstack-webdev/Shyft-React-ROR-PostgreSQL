class AddCityToEventLocation < ActiveRecord::Migration
  def change
    add_column :event_locations, :city, :string
    add_column :event_locations, :city_id, :integer
  end
end

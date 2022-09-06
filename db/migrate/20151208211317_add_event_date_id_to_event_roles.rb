class AddEventDateIdToEventRoles < ActiveRecord::Migration
  def change
    add_column :event_roles, :event_date_id, :integer
  end
end

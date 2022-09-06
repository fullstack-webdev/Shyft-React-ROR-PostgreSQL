class AddEventRolesToEvent < ActiveRecord::Migration
  def change
    add_column :event_roles, :event_id, :integer
    add_reference :event_roles, :events, index: true
    add_foreign_key :event_roles, :events
  end
end

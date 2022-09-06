class AddEventDateShiftIdToEventRole < ActiveRecord::Migration
  def change
    add_column :event_roles, :event_date_shift_id, :integer
    add_column :event_roles, :ambassador_id, :integer
  end
end

class ChangeBusyShiftColumnDateType < ActiveRecord::Migration
  def change
    remove_column :busy_shifts, :start_time
    remove_column :busy_shifts, :end_time
    add_column :busy_shifts, :start_time, :datetime
    add_column :busy_shifts, :end_time, :datetime
  end
end

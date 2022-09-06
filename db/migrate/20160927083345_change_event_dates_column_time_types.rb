class ChangeEventDatesColumnTimeTypes < ActiveRecord::Migration
  def up
    remove_column :event_date_shifts, :start_time
    add_column :event_date_shifts, :start_time, :datetime
    remove_column :event_date_shifts, :end_time
    add_column :event_date_shifts, :end_time, :datetime
  end

  def down
    remove_column :event_date_shifts, :start_time
    add_column :event_date_shifts, :end_time, :time
    remove_column :event_date_shifts, :end_time
    add_column :event_date_shifts, :end_time, :time
  end
end

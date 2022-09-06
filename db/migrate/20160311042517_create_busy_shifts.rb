class CreateBusyShifts < ActiveRecord::Migration
  def change
    create_table :busy_shifts do |t|
      t.string :day
      t.datetime :start_time
      t.datetime :end_time
      t.integer :ambassador_id
      t.timestamps null: false
    end
  end
end

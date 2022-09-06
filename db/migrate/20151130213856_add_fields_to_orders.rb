class AddFieldsToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :start_date, :date
    add_column :orders, :end_date, :date
    add_column :orders, :start_time, :time
    add_column :orders, :end_time, :time
  end
end

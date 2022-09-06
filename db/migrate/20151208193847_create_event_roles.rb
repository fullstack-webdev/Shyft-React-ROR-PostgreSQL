class CreateEventRoles < ActiveRecord::Migration
  def change
    create_table :event_roles do |t|
      t.string :type
      t.integer :hourly_rate
      t.integer :quantity

      t.timestamps null: false
    end
  end
end

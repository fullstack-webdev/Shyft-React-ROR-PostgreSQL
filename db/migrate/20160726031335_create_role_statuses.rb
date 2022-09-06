class CreateRoleStatuses < ActiveRecord::Migration
  def change
    create_table :role_statuses do |t|
      t.string :status
      t.string :displayname

      t.timestamps null: false
    end
  end
end

class AddRoleStatusToEventRole < ActiveRecord::Migration
  def change
    add_column :event_roles, :role_status_id, :integer, :default => 1
  end
end

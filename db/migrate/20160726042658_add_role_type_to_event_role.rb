class AddRoleTypeToEventRole < ActiveRecord::Migration
  def change
    add_column :event_roles, :role_type_id, :integer, :default => 1
  end
end

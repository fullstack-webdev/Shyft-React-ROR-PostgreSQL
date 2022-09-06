class ChangeFieldNameInEventRoles < ActiveRecord::Migration
  def change
  	rename_column :event_roles, :type, :role
  end
end

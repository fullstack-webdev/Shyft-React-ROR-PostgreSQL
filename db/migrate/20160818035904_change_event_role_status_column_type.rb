class ChangeEventRoleStatusColumnType < ActiveRecord::Migration
  def self.up
    change_table :event_roles do |t|
      t.rename :role_status_id, :role_status
      t.change :role_status, :string, :default => "empty"
      t.remove :role
      t.remove :events_id
    end
  end

  # Migrating down from string to integer is never going to happen
  # def self.down
  #   change_table :event_roles do |t|
  #     t.change :role_status, 'integer USING CAST(role_status AS integer)'
  #     t.rename :role_status, :role_status_id
  #   end
  # end
end

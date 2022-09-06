class CreateRoleTypes < ActiveRecord::Migration
  def change
    create_table :role_types do |t|
      t.string :type_of
      t.string :displayname
      t.string :abbrv

      t.timestamps null: false
    end
  end
end

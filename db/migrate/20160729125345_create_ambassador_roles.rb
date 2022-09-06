class CreateAmbassadorRoles < ActiveRecord::Migration
  def change
    create_table :ambassador_roles do |t|
      t.integer :ambassador_id
      t.integer :role_type_id

      t.timestamps null: false
    end
  end

  # NOTE - This was being shitty migrating
  # Ambassador.find_each do |a|
  #   if a.ambassador_roles == nil
  #     r = AmbassadorRole.create!(
  #     ambassador_id: a.id,
  #     role_type_id:1)
  #   end
  # end
end

class CreatePropertyAmbassadors < ActiveRecord::Migration
  def change
    create_table :property_ambassadors do |t|
      t.integer :ambassador_id
      t.integer :property_id

      t.timestamps null: false
    end
  end
end

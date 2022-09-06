class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :full_name
      t.string :company
      t.string :telephone
      t.string :email
      t.string :address_1
      t.string :address_2
      t.string :city
      t.string :state
      t.string :country

      t.timestamps null: false
    end
  end
end

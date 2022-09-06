class CreateLineItems < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
      t.references :ambassador, index: true
      t.belongs_to :cart, index: true

      t.timestamps null: false
    end
    add_foreign_key :line_items, :ambassadors
    add_foreign_key :line_items, :carts
  end
end

class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.text :content
      t.string :name
      t.string :email
      t.decimal :rating
      t.references :ambassador, index: true

      t.timestamps null: false
    end
    add_index :reviews, [:ambassador_id, :created_at]
  end
end

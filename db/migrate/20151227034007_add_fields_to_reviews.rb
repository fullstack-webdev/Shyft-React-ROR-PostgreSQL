class AddFieldsToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :star, :integer, default: 5
    add_reference :reviews, :agency, index: true
    add_foreign_key :reviews, :agencies
  end
end

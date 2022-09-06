class AddFieldsToAmbassador < ActiveRecord::Migration
  def change
    add_column :ambassadors, :image, :string
  end
end

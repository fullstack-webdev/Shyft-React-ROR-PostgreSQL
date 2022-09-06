class AddDetailsToAmbassador < ActiveRecord::Migration
  def change
    add_column :ambassadors, :city, :string
    add_column :ambassadors, :state, :string
    add_column :ambassadors, :about, :text
  end
end

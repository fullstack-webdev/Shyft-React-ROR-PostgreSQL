class FixColumnName < ActiveRecord::Migration
  def change
  	rename_column :images, :post_id, :ambassador_id
  end
end

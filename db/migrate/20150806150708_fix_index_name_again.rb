class FixIndexNameAgain < ActiveRecord::Migration
  def change
  	rename_index :images, 'nindex_images_on_ambassador_id', 'index_images_on_ambassador_id'
  end
end

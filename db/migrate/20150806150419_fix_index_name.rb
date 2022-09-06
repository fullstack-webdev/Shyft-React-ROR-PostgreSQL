class FixIndexName < ActiveRecord::Migration
  def change
  	rename_index :images, 'index_images_on_post_id', 'nindex_images_on_ambassador_id'
  end
end

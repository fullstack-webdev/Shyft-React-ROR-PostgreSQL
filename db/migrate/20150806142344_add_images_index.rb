class AddImagesIndex < ActiveRecord::Migration
  def change
  	add_index :images, [:ambassador_id], :name => 'index_images_on_post_id'
  end
end

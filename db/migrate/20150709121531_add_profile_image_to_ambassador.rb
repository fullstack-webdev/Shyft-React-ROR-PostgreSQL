class AddProfileImageToAmbassador < ActiveRecord::Migration
  def change
    add_column :ambassadors, :profile_image_id, :string
  end
end

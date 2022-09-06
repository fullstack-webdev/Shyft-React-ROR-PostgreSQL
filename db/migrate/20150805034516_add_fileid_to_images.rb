class AddFileidToImages < ActiveRecord::Migration
  def change
    add_column :images, :file_id, :string
  end
end

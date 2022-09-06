class AddFullNameAndSlugToAmbassador < ActiveRecord::Migration
  def change
    add_column :ambassadors, :full_name, :string
    add_column :ambassadors, :slug, :string
    add_index :ambassadors, :slug, unique: true
  end
end

class AddFieldsToAmbassadors < ActiveRecord::Migration
  def change
    add_column :ambassadors, :roles, :string
  end
end

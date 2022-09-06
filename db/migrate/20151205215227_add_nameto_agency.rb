class AddNametoAgency < ActiveRecord::Migration
  def change
  	add_column :agencies, :first_name, :string, null:false, default:""
  	add_column :agencies, :last_name, :string, null:false, default:""
  end
end
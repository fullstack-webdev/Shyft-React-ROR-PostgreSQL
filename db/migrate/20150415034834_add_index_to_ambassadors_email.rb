class AddIndexToAmbassadorsEmail < ActiveRecord::Migration
  def change
    add_index :ambassadors, :email, unique: true
  end
end

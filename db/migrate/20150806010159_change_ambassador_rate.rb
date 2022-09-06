class ChangeAmbassadorRate < ActiveRecord::Migration
  def change
    change_column :ambassadors, :rate, :decimal
  end
end

class AddResponseToAmbassadors < ActiveRecord::Migration
  def change
  	add_column :ambassadors, :response_time, :integer, default: 8
  	add_column :ambassadors, :acceptance_rate, :integer, default: 100
  end
end
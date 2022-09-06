class AddRateToAmbassadors < ActiveRecord::Migration
  def change
    add_column :ambassadors, :rate, :decimal
    add_column :ambassadors, :rate_currency, :string
  end
end

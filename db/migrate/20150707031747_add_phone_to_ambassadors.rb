class AddPhoneToAmbassadors < ActiveRecord::Migration
  def change
    add_column :ambassadors, :phone_number, :string
  end
end

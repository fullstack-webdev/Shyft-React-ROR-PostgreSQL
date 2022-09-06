class AddPhoneAndEmailVerificationToAmbassador < ActiveRecord::Migration
  def change
    add_column :ambassadors, :phone_confirmed, :boolean, default:false
    add_column :ambassadors, :email_confirmed, :boolean, default:false
  end
end

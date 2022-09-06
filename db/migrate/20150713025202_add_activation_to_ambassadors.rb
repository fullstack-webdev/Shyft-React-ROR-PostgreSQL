class AddActivationToAmbassadors < ActiveRecord::Migration
  def change
    add_column :ambassadors, :activation_digest, :string
    add_column :ambassadors, :activated, :boolean, default:false
    add_column :ambassadors, :activated_at, :datetime
  end
end

class AddResetToAmbassadors < ActiveRecord::Migration
  def change
    add_column :ambassadors, :reset_digest, :string
    add_column :ambassadors, :reset_sent_at, :datetime
  end
end

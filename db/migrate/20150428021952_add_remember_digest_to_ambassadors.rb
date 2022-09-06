class AddRememberDigestToAmbassadors < ActiveRecord::Migration
  def change
    add_column :ambassadors, :remember_digest, :string
  end
end

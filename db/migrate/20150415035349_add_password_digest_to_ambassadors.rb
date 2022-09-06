class AddPasswordDigestToAmbassadors < ActiveRecord::Migration
  def change
    add_column :ambassadors, :password_digest, :string
  end
end

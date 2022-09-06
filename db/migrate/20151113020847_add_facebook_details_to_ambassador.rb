class AddFacebookDetailsToAmbassador < ActiveRecord::Migration
  def change
    add_column :ambassadors, :provider, :string
    add_column :ambassadors, :uid, :string
    add_column :ambassadors, :name, :string
    add_column :ambassadors, :oauth_token, :string
    add_column :ambassadors, :oauth_expires_at, :datetime
  end
end

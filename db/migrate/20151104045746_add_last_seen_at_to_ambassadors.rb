class AddLastSeenAtToAmbassadors < ActiveRecord::Migration
  def change
    add_column :ambassadors, :last_seen_at, :datetime
  end
end

class AddExpiredRoleStatus < ActiveRecord::Migration
  def change
    RoleStatus.create(:status=>'expired', :displayname=>"Expired")
  end
end

class LoadRoleStatus < ActiveRecord::Migration
  def self.up
     statuses = [
       {'status'=>'empty', 'displayname'=>'None'},
       {'status'=>'short-list', 'displayname'=>'Short List'},
       {'status'=>'pending', 'displayname'=>'Pending'},
       {'status'=>'confirmed', 'displayname'=>'Confirmed'},
       {'status'=>'declined', 'displayname'=>'Declined'}
     ]
     for status in statuses
         RoleStatus.create(:status=>status["status"], :displayname=>status["displayname"])
     end
   end

   def self.down
     RoleStatus.delete_all
   end
end

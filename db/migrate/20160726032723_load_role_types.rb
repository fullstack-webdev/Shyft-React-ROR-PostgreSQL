class LoadRoleTypes < ActiveRecord::Migration
  def self.up
     type_ofs = [
       {'type_of'=>'brand-ambassador', 'displayname'=>'Ambassador', 'abbrv'=>'A'},
       {'type_of'=>'food-sampler', 'displayname'=>'Sampler', 'abbrv'=>'S'},
       {'type_of'=>'team-lead', 'displayname'=>'Team Lead', 'abbrv'=>'T'},
       {'type_of'=>'bartender', 'displayname'=>'Bartender', 'abbrv'=>'B'},
       {'type_of'=>'promo-model', 'displayname'=>'Promo Model', 'abbrv'=>'P'}
     ]
     for t in type_ofs
         RoleType.create(:type_of=>t["type_of"], :displayname=>t["displayname"], :abbrv=>t["abbrv"])
     end
   end

   def self.down
     RoleType.delete_all
   end
end

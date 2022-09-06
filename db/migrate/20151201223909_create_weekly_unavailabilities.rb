class CreateWeeklyUnavailabilities < ActiveRecord::Migration
  def up
    create_table :weekly_unavailabilities do |t|
      t.time :sunday_start, :null => true
      t.time :sunday_end, :null => true
      t.time :monday_start, :null => true
      t.time :monday_end, :null => true
      t.time :tuesday_start, :null => true
      t.time :tuesday_end, :null => true
      t.time :wednesday_start, :null => true
      t.time :wednesday_end, :null => true
      t.time :thursday_start, :null => true
      t.time :thursday_end, :null => true
      t.time :friday_start, :null => true
      t.time :friday_end, :null => true
      t.time :saturday_start, :null => true
      t.time :saturday_end, :null => true
      t.integer :ambassador_id

      t.timestamps null: false
    end

    Ambassador.find_each do |a|      
      if a.weekly_unavailability == nil 
        a.weekly_unavailability = WeeklyUnavailability.create!( 
          sunday_start: nil,
          sunday_end: nil, 
          monday_start: nil,
          monday_end: nil,
          tuesday_start: nil,
          tuesday_end: nil,
          wednesday_start: nil,
          wednesday_end: nil,
          thursday_start: nil,
          thursday_end: nil,
          friday_start: nil,
          friday_end: nil,
          saturday_start: nil,
          saturday_end: nil)
        if a.phone_number == nil || a.phone_number.length != 10
          a.phone_number = "0000000000"
        end
        a.save!        
      end
    end
  end

  def down
    drop_table :weekly_unavailabilities
      Ambassador.find_each do |a|      
        a.weekly_unavailabilities = nil
      a.save!
    end    
  end
end

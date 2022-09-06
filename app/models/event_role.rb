class EventRole < ActiveRecord::Base
    belongs_to :event_date #remove this eventually -dg
    belongs_to :event_date_shift
    belongs_to :ambassador

    # NOTE We can remove the quanity and role string from this table unless
    # we find another use for them

    # returns the number of total hours for this role
    def total_hours
      shift = EventDateShift.find(self.event_date_shift_id)
      shift.total_hours
    end

    # returns the hourly rate * number of hours for this role
    def cost
      return self.hourly_rate * self.total_hours
    end
    
end

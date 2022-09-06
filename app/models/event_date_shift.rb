class EventDateShift < ActiveRecord::Base
    belongs_to :event_date
    has_many :event_roles, :dependent => :destroy

    def ends_on_following_day?
      self.start_time.wday < self.end_time.wday
    end

    def total_hours
      ( self.end_time - self.start_time ) / 3600
    end
end

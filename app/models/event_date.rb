class EventDate < ActiveRecord::Base
	has_many :event_roles, :dependent => :destroy #remove this relationship eventually -dg
  has_many :event_date_shifts, :dependent => :destroy
	belongs_to :event_location
	accepts_nested_attributes_for :event_roles, :allow_destroy => true

  def display_name
    self
  end

  def time_span
    self.event_date.to_s  + '@' + self.start_time.to_s + '-' + self.end_time.to_s
  end
end

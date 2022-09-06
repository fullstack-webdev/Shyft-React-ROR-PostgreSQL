class EventLocation < ActiveRecord::Base
	has_many :event_dates, :dependent => :destroy
	# has_many :event_roles, through: :event_dates
	belongs_to :event
	# accepts_nested_attributes_for :event_dates, :allow_destroy => true

  # label: string, address: string, zip: string, state: string, country: string
  validates :label, presence: true, length: {minimum: 3}
  validates :address, length: {minimum: 3}
  validates :zip, length: {minimum: 5, maximum: 7}
  validates :state, presence: true
  validates :city, presence: true
  validates :country, presence: true

	def display_name
		self.address
	end

	def display_address
		[self.label, self.address, self.zip, self.city, self.state, self.country].join(', ')
	end
end

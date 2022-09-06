class Property < ActiveRecord::Base
  has_many :property_ambassadors

  validates_presence_of :name
end

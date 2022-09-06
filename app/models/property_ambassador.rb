class PropertyAmbassador < ActiveRecord::Base
  belongs_to :ambassador
  belongs_to :property
end

class LineItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :ambassador
  belongs_to :cart

  validates :ambassador_id, presence: true

	def total_price
		ambassador.rate * quantity
	end  

end

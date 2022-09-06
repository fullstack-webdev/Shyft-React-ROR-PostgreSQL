class Cart < ActiveRecord::Base
	has_many :line_items, dependent: :destroy
	has_one :order

	def add_ambassador(ambassador_id)
		current_item = line_items.find_by(ambassador_id: ambassador_id)
		if current_item
		  current_item.quantity += 1
		else
		  current_item = line_items.build(ambassador_id: ambassador_id)
		end
	  current_item
	end

	def subtotal
		line_items.to_a.sum { |item| item.total_price }
		# sub_total + service_fee
	end


	def service_fee
		subtotal * 0.05
		# line_items.to_a.sum { |item| item.total_price }
	end

	def total_price
		# line_items.to_a.sum { |item| item.total_price }
		service_fee + subtotal
	end

end

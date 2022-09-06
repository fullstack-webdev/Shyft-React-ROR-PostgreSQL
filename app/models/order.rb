class Order < ActiveRecord::Base
	has_many :line_items, dependent: :destroy
	has_many :ambassadors, :through => :line_items
	belongs_to :cart

	def process_payment

		# removed this because we no longer need to create customers for each order
	  # customer = Stripe::Customer.create(
	  #   email: email,
	  #   card: card_token
	  # )
		#

    charge = Stripe::Charge.create(
      amount: @total_amount.to_int,
      description: 'Shyft Booking',
      currency: 'cad',
			source: card_token
    )

  end

  def add_line_items_from_cart(cart)
  	cart.line_items.each do |item|
      item.cart_id = nil
      line_items << item
		end

		@total_amount = cart.total_price.to_f * 100
	end

end

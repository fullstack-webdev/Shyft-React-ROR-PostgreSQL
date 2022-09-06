class LineItemsController < ApplicationController
	include CurrentCart
	before_action :set_cart, only: [:create, :destroy]

	def create
    ambassador = Ambassador.friendly.find(params[:ambassador_id])
    @line_item = @cart.add_ambassador(ambassador.id)

		respond_to do |format|
			if @line_item.save
				format.html { redirect_to @line_item.cart }
				format.json { render action: 'show', status: :created, location: @line_item }
			else
				format.html { render action: 'new' }
				format.json { render json: @line_item.errors, status: :unprocessable_entity }
			end
		end
	end

	def destroy
		line_item = LineItem.find(params[:id])
    line_item.delete

    redirect_to cart_path(session[:cart_id])
  end

	def line_item_params
		params.require(:line_item).permit(:ambassador_id)
	end

end

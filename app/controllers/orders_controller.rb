class OrdersController < ApplicationController
  include CurrentCart
  before_action :set_cart, only: [:new, :create]
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_agency!

  # GET /orders
  # GET /orders.json
  def index
    redirect_to root_url
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    if @cart.line_items.empty?
      redirect_to ambassadors_url, notice: "Your cart is empty"
      return
    end

    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  # POST /orders.json

  def create
    @order = Order.create order_params

    @order.add_line_items_from_cart(@cart)

    raise "Please, check booking errors" unless @order.valid?

    @order.process_payment
    @order.save
    Cart.destroy(session[:cart_id])
    session[:cart_id] = nil
    redirect_to confirm_booking_path

  rescue Stripe::CardError => e
    redirect_to error_booking_path :flash => {:success => e.message}
  end

    #respond_to do |format|
      #if @order.save
        #Cart.destroy(session[:cart_id])
        #session[:cart_id] = nil

       # format.html { redirect_to @order, notice: 'Thank you for your order.' }
       # format.json { render action: 'show', status: :created, location: @order }
      # else
      #  format.html { render action: 'new' }
      #  format.json { render json: @order.errors, status: :unprocessable_entity }
      # end
    # end
  # end



  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:cart_id, :full_name, :company, :telephone, :email, :address_1, :address_2, :city, :state, :zip_code, :country, :card_token)
    end

    def stripe_params
      params.permit :stripeEmail, :stripeToken
    end
end

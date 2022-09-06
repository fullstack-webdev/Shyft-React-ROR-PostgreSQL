class CartsController < SessionsController
  before_action :authenticate_agency!
	before_action :set_cart, only: [:show, :edit, :update, :destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :invalid_cart

	def show
	end

	def index
		@carts = Cart.all
	end

  # GET /carts/new
  def new
    @cart = Cart.new
  end

  # GET /carts/1/edit
  def edit
  end

  # POST /carts
  # POST /carts.json
  def create
    @cart = Cart.new(cart_params)

		respond_to do |format|
      if @cart.save
        format.html { redirect_to @cart, notice: 'Cart was successfully created.' }
        format.json { render :show, status: :created, location: @cart }
      else
        format.html { render :new }
        format.json { render json: @cart.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /carts/1
  # PATCH/PUT /carts/1.json`
  def update

		for i in 0..@cart.line_items.count-1 do
			@line_item = LineItem.find(params[:line_item_ids][i])
			@line_item.update_attribute(:quantity, params[:quantity][i])
		end

		redirect_to @cart

		# respond_to do |format|
    #   if @cart.update(cart_params)
    #     format.html { redirect_to @cart, notice: 'Cart was successfully updated.' }
    #     format.json { render :show, status: :ok, location: @cart }
    #   else
    #     format.html { render :edit }
    #     format.json { render json: @cart.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # DELETE /carts/1
  # DELETE /carts/1.json
  def destroy
    @cart.destroy if @cart.id == session[:cart_id]
    session[:cart_id] = nil
    respond_to do |format|
      format.html { redirect_to root_url, notice: 'Your cart is currently empty' }
      format.json { head :no_content }
    end
  end


	def some_action
	end

	 private
    # Use callbacks to share common setup or constraints between actions.
    def set_cart
      @cart = Cart.find(params[:id])
    end

    def cart_params
      params[:cart]
    end

    def invalid_cart
      logger.error "Attempt to access invalid cart #{params[:id]}"
      redirect_to ambassadors_url, notice: 'Invalid cart'
    end


end

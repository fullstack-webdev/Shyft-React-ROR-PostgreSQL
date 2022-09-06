class ImagesController < ApplicationController
	respond_to :js
	def destroy
		@image = Image.find(params[:id])
		ambassador = @image.ambassador

		@image.destroy
		@images = Image.where(ambassador_id: ambassador.id)


		# respond_to :js
		respond_to do |format|
	    	format.js {}
	  	end
	end

	def show
		@images = Ambassador.images

		@ambassador = Ambassador.friendly.find(params[:id])  
	end
end

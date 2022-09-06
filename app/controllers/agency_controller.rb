class AgencyController < ApplicationController
	before_action :authenticate_agency!
	layout 'application'

	def show
		
	end

end

class AmbassadorActivationsController < ApplicationController
  def edit    
    user = Ambassador.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.confirm_email
      log_in user
      redirect_to edit_ambassador_path(user), :flash => { :success => "Thanks for confirming your email with Shyft!" }
    else
      redirect_to root_url, :flash => {:danger => "Sorry, this url is not valid. Please try again or contact bookings@shyftworks.com"}
    end
  end
end

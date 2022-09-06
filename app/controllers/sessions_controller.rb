class SessionsController < ApplicationController
  def new
  end

  def create
  	# @ambassador = Ambassador.find_or_create_from_auth_hash(auth_hash)
  	#  #session[:user_id] = @ambassador.id
  	# self.current_user = @ambassador 
   #  redirect_to root_url
    user = Ambassador.from_omniauth(env["omniauth.auth"])
    session[:user_id] = user.id

    redirect_to root_url 
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
  protected

   def auth_hash
     request.env['omniauth.auth']
   end

end

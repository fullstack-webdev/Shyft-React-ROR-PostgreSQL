class AmbassadorSessionsController < SessionsController
  def new
  end

  def create    
    if ambassador && ambassador.authenticate(params[:session][:password])
      # COMMENTING THIS OUT SINCE WE WILL BE ACTIVATING 
      # AMBASSADORS OURSELVES AND IT IS NOT DEPENDANT ON THE EMAIL
      # if ambassador.activated?
        log_in ambassador
        params[:session][:remember_me] == '1' ? remember(ambassador) : forget(ambassador)

        if session[:stored_location]
          redirect_to session[:stored_location]
        else
          if ambassador.is_new?
            redirect_back_or ambassador
          else
            redirect_back_or dashboard_path
          end  
        end        
      # else
      #   message  = "Account not activated. "
      #   message += "Check your email for the activation link."
      #   flash[:warning] = message
      #   redirect_to root_url
      # end
    else
      # Render an error because the ambassador requested is invalid
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def ambassador
    @ambassador = Ambassador.find_by(email: params[:session][:email].downcase)
  end

end

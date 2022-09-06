module AmbassadorSessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end

  # Returns the current logged-in user (if any).
  # Will likely have to check against agencies in the future as well.

  # def logged_in
  #   !current_user.nil?
  # end

end

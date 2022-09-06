class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  before_action :set_last_seen_at, if: proc { logged_in? }
  protect_from_forgery with: :exception

  include AmbassadorSessionsHelper
  include SessionsHelper

  def disable_nav
      @disable_nav = true
  end

  config.relative_url_root = ""

	private

	def set_last_seen_at
		current_user.update_attribute(:last_seen_at, Time.now)
	end

  def after_sign_in_path_for(resource)
    sign_in_url = new_agency_session_url
    if request.referrer == sign_in_url
      events_path(agency_id:resource.id)
    else
      stored_location_for(resource) || request.referrer || root_path
    end
  end

  private

  def current_user
    @current_user ||= Ambassador.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def authenticated
    if !current_agency.nil?
      :authenticate_agency!
    else
      unless logged_in?
        session[:stored_location] = request.env['REQUEST_PATH']
        redirect_to login_path
      end
    end
  end
end

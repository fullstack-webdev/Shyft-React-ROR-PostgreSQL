class ShyftPagesController < ApplicationController

  before_filter :disable_nav, only: [:alt_home, :request_invite]

  def request_invite
  end

  def home
    @agency_logged_in = !current_agency.nil?
  end

  def how_to_hire
  end

  def how_to_work
  end

  def why_shyft
  end

  def ambassadors
  end

  def cphollister_profile
  end

  def cphollister_booking
  end

  def confirmation
  end

  def agency_request_account
  end
end

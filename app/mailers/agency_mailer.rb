class AgencyMailer < ApplicationMailer
	default from: "Chris Hollister <chris@shyftworks.com>"
  layout 'mailer'

  # def request_agency_account(agency)
  #   @agency = agency
  #   mail to: 'bookings@shyftworks.com', reply_to: agency.email, subject: "Agency Account Requested"
  # end
  def account_signup_admin(agency)
    @agency = agency
    mail to: 'bookings@shyftworks.com', reply_to: agency.email, subject: "Agency Account Created"
  end
end

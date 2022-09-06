class AmbassadorMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.ambassador_mailer.account_activation.subject
  #
  def account_activation(ambassador)
    @ambassador = ambassador
    mail to: ambassador.email, subject: "Account activation"
  end

  def account_signup_admin(ambassador)
    @ambassador = ambassador
    mail to: 'bookings@shyftworks.com', reply_to: ambassador.email, subject: "Account Created"
  end

  def new_message(ambassador_id, message, agency)
    @ambassador = Ambassador.find_by(id:ambassador_id)
    @message = message
    @agency = agency
    @subject = "New Message From:" + @agency.first_name + " @ " + @agency.company_name
    load_image_assets
    mail to: @ambassador.email, bcc: 'bookings@shyftworks.com', reply_to: 'bookings@shyftworks.com', subject: @subject
  end
  def load_image_assets 
    attachments.inline['logo.png'] = File.read(Rails.root.join('app/assets/images/shyft-logo-main.png'))
  end
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.ambassador_mailer.password_reset.subject
  #
  def password_reset(ambassador)
    @ambassador = ambassador
    mail to: ambassador.email, subject: "Password reset"
  end
end

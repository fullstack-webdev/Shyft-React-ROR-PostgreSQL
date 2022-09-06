# Preview all emails at http://localhost:3000/rails/mailers/ambassador_mailer
class AmbassadorMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/ambassador_mailer/account_activation
  def account_activation
    ambassador = Ambassador.first
    ambassador.activation_token = Ambassador.new_token
    AmbassadorMailer.account_activation(ambassador)
  end

  # Preview this email at http://localhost:3000/rails/mailers/ambassador_mailer/password_reset
  def password_reset
    ambassador = Ambassador.first
    ambassador.reset_token = Ambassador.new_token
    AmbassadorMailer.password_reset(ambassador)
  end
end

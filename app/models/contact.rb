class Contact < MailForm::Base
  attribute :company_name,      :validate => true
  attribute :contact_name,      :validate => true
  attribute :phone,      :validate => true
  attribute :email,     :validate => /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i
  attribute :start_date,	:validate => true
  attribute :end_date,	:validate => true
  attribute :location,	:validate => true
  attribute :amount_of_hours,	:validate => true
  attribute :message
  attribute :nickname,  :captcha  => true
  attribute :ambassador_id, :validate => true
  attribute :ambassador_first_name, :validate => true
  attribute :ambassador_last_name, :validate => true
  attribute :ambassador_email, :validate => true
  attribute :ambassador_rate, :validate => true


  #attribute :additional_field, :captcha => true
  append :user_agent, :session

  # Declare the e-mail headers. It accepts anything the mail method
  # in ActionMailer accepts.
  def headers
    {
      :subject => "New Booking Request Through Shyft",
      :to => "bookings@shyftworks.com",
      :from => %("Shyft" <#{email}>), #%("#{company_name}" <#{email}>),
      :body => "#{ambassador_first_name} #{ambassador_last_name},
        You have a new booking request for #{amount_of_hours} hours. Please review the below details and respond to the request.

      Company Name: #{company_name}
      Contact Name: #{contact_name}
      Starting Date: #{start_date}
      Ending Date: #{end_date}
      Location: #{location}
      Work Details: #{message}

      Ambassador Info:
      Name: #{ambassador_first_name} #{ambassador_last_name}
      Email: #{ambassador_email}
      Rate: #{ambassador_rate}

      If you have any questions for the company please feel free to respond with those questions.

      Shyft
      bookings@shyftworks.com
      1-800-719-6778"
    }
  end
end

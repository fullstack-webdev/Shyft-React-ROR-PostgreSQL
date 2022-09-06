class ContactsController < ApplicationController
  before_action :authenticate_agency!
  before_filter :authenticate_agency!

  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(params[:contact])
    @contact.ambassador_first_name = params[:ambassador_id]

    update_contact

    @contact.request = request

    if @contact.deliver
      redirect_to ambassador_path(params[:ambassador_id]), :flash => { :notice => 'Thank you for your message. I will contact you soon!' }
    else
      redirect_to ambassador_path(params[:ambassador_id]), :flash => { :error => 'Cannot send message, please ensure you filled out the entire form.' }
    end
  end

  def update_contact
    @contact.ambassador_id = params[:ambassador_id]
    @contact.ambassador_first_name = params[:ambassador_first_name]
    @contact.ambassador_last_name = params[:ambassador_last_name]
    @contact.ambassador_email = params[:ambassador_email]
    @contact.ambassador_rate = params[:ambassador_rate]
  end
end

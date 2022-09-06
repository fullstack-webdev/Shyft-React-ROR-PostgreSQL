class MessagesController < ApplicationController
	before_action :authenticated
	before_action :set_conversation

	def index
		@user_type = ''
		# check if event is over or not
		# if event is over, we can not exchange messages
		@event_is_over = false
		if @conversation.event.overall_end_date < Date.today 
			@event_is_over = true
		end

		if current_agency == @conversation.sender || current_user == @conversation.recipient
			@user_type = current_agency == @conversation.sender ? 'agency' : 'ambassador'
			@other = current_agency == @conversation.sender ? @conversation.recipient : @conversation.sender
			@messages = @conversation.messages.order("created_at DESC")

			#mark all messages read
			@messages.update_all(is_read: true)
		else
			redirect_to conversations_path, alert: "You don't have permission to view this."
		end
	end

	def create
		@message = @conversation.messages.new(message_params.merge({:is_read => false}))
		@messages = @conversation.messages.order("created_at DESC")

		if @message.save
			send_message_notification
		end
	end

	private

	def send_message_notification
		# Sends new message email.
    	if !current_user.nil?
    		return
    	end

    	if !current_agency.nil?
    		AmbassadorMailer.new_message(@conversation.recipient_id, @message, current_agency).deliver_now
    		return
    	end
	end

	def send_agency_email

	end

	def set_conversation
		@conversation = Conversation.find(params[:conversation_id])
	end

	def message_params
		params.require(:message).permit(:content, :user_id, :user_type)
	end
end

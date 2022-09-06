class ConversationsController < ApplicationController
	before_action :authenticated
  # push this
	def index
		if params[:event_id]
			@event = Event.find(params[:event_id])
			ambassador_ids = @event.event_roles.where(role_status: 'confirmed').pluck('ambassador_id')
			@confirmed_ambassadors = Ambassador.where(id: ambassador_ids)

			
			
			if !current_agency.nil?		
				@conversations = @event.conversations.involving_agency(current_agency).involving_ambassadors(ambassador_ids)
			elsif !current_user.nil?			
				@conversations = @event.conversations.involving_ambassador(current_user)
			else
				@conversations = nil
			end	
			#get confirmed ambassadors only
		else
			@event = nil
			@confirmed_ambassadors = nil
			@conversations = nil
		end
	end

	def ambassador_messages
		if !current_user.nil?

			if params[:event_id]
				@event = Event.find(params[:event_id])
				@conversations = Conversation.involving_ambassador(current_user)
			else
				@event = nil
			end
		elsif !current_user.nil?
			@conversations = Conversation.involving_ambassador(current_user)
		else
			@conversations = nil
		end
	end

	def create
		if Conversation.between(params[:sender_id], params[:recipient_id]).present?
			@conversation = Conversation.between(params[:sender_id], params[:recipient_id]).first
		else
			@conversation = Conversation.create(conversation_params)
		end

		redirect_to conversation_messages_path(@conversation)
	end

	private
	def conversation_params
		params.permit(:sender_id, :recipient_id)
	end
end
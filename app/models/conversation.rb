class Conversation < ActiveRecord::Base
	belongs_to :sender, foreign_key: :sender_id, class_name: 'Agency'
	belongs_to :recipient, foreign_key: :recipient_id, class_name: 'Ambassador'
	belongs_to :event
	has_many :messages, dependent: :destroy
	
	# why do we need to restrict this setting?
	#validates_uniqueness_of :sender_id, scope: :recipient_id

	scope :involving_agency, -> (user) do
		where("conversations.sender_id = ?", user.id)
	end

	scope :involving_ambassador, -> (user) do
		where("conversations.recipient_id = ?", user.id)
	end

	scope :involving_ambassadors, -> (user_ids) do
		where(recipient_id: user_ids)
	end

	scope :between, -> (sender_id, recipient_id) do
		where("(conversations.sender_id = ? AND conversations.recipient_id = ?) OR (conversations.sender_id = ? AND conversations.recipient_id = ?)",
			sender_id, recipient_id, recipient_id, sender_id)
	end	
end


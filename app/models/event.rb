class Event < ActiveRecord::Base
	has_many :event_locations, :dependent => :destroy
	has_many :event_dates, through: :event_locations
	has_many :event_roles, through: :event_dates
	has_many :conversations
	belongs_to :agency
  	has_one :booking
	accepts_nested_attributes_for :event_locations, :allow_destroy => true


	def total_earning_by(ambassaor_id, status = STATUS_CONFIRMED)
		event_roles = EventRole.where('event_id = ? AND ambassador_id = ? AND role_status = ?', self.id, ambassaor_id, status)

		sub_total_earning = BigDecimal.new(0)

		event_roles.each do |role|
			sub_total_earning += role.cost
		end

    ambassador_service_fee = BigDecimal.new("0.1")
		total_earning = sub_total_earning - (sub_total_earning * ambassador_service_fee)
	end

	def overall_start_date
		event_dates.pluck(:event_date).min
	end

	def overall_end_date
		event_dates.pluck(:event_date).max
	end

	def total_unread_messages_by_agency
		total = 0

		conversations.each do |conversation|
			total += conversation.messages.where('is_read = false AND user_type = ?', 'ambassador').count
		end
		total
	end

	def total_unread_messages_by_ambassador(ambassador)
		total = 0

		conversations.involving_ambassador(ambassador).each do |conversation|
			total += conversation.messages.where('is_read = false AND user_type = ?', 'agency').count
		end
		total
	end
end

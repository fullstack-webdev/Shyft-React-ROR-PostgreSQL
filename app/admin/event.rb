ActiveAdmin.register Event do


# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end
index do
	column :agency
	column "Evnet Name", :name
	column "Created", :created_at
	actions
end

show do
	attributes_table do
	row "Summary", :event do |event|
		
		columns do
			column  do
				span "# of Locations"
					ul :style =>"list-style-type:none;" do
										li do
						event.event_locations.count
						end
					end
			end
			column  do
				span "# of Dates"
					ul :style =>"list-style-type:none;" do
						event.event_locations.each do |event_location|
										li do
							event_location.event_dates.count
						end
						end
					end
			end
	   		column  do
				span "# of Ambassadors"
					ul :style =>"list-style-type:none;" do
										li do
						event.booking.booking_staff.count
						end
					end
			end
	   		column  do
				span "Cost"
					ul :style =>"list-style-type:none;" do
						event.booking.booking_transactions.each do |booking_transaction|
										li do
							booking_transaction.amount
						end
						end
					end
			end
		end
	end
end
	attributes_table do
	row :agency
	row :name
	row :event_details
	row :created_at
	
panel "Locations" do
  resource.event_locations.each do |event_location|

    attributes_table_for event_location do
      row :label
      row :address
      row :zip
      row :state
      row :country
      row :notes

      panel "Event Dates" do
        event_location.event_dates.each do  |event_date|

          
            	attributes_table_for event_date.event_date_shifts do
            		row :start_time
            		row :end_time
            	
            panel "Ambassadors" do
            	event_date.event_roles.each do |ambassador|
            		table_for ambassador do
                  		column "Photo" do
                  			if ambassador.ambassador != nil
                  				ul :style =>"list-style-type:none;" do
                  			ambassador.ambassador.images.first(1).each do |img|
										li do

									    link_to attachment_image_tag(img, :file, :fill, 50, 50), ambassador_path(img.ambassador.id)
										end 
									end
								end
							end
						end
                  		column :ambassador
                  		column :role_status do |ambassador|
                  			if ambassador.role_status == "confirmed" 
                  				status_tag 'confirmed', :ok
                  			elsif ambassador.role_status == "empty"
                  			
                  			else 
                  				status_tag 'pending', :warning
                  			
                  			end	
                  		end
                  		column :quantity
                  		column :hourly_rate do |ambassador|
                  			number_to_currency ambassador.hourly_rate
                  		end

                end
              end

            end
          end

        end
      end
    end
  end
end
end
	active_admin_comments
end



permit_params :agency, :name, :event_details, :created_at, event_locations_attributes: [:id, :label, :address, :zip, :state, :country, :notes, :_destroy, event_dates_attributes: [:event_date, :start_time, :end_time, event_roles_attributes: [:role, :hourly_rate, :quantity]]] 

form do |f| 
	f.inputs "Event" do
		f.input :agency
		f.input :name
		f.input :event_details
		f.input :created_at
		f.has_many :event_locations, allow_destroy: true do |event_location|
			event_location.input :label
			event_location.input :address
			event_location.input :zip
			event_location.input :state
			event_location.input :country
			event_location.input :notes
			# event_location.has_many :event_dates do |event_date|
				# event_date.has_many :event_date_shifts, allow_destroy: true do |event_date_shift|
				# event_date_shift.input :event_date_id
				# event_date_shift.input :start_time
				# event_date_shift.input :end_time
				# event_date.has_many :event_roles, allow_destroy: true do |event_role|
				# 	event_role.input :role
				# 	event_role.input :hourly_rate
				# 	event_role.input :quantity	
				# end	

			# end		
		end
	end
	 f.button "Save"
end			


end

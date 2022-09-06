ActiveAdmin.register Agency do

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
filter :company_name
filter :first_name
filter :last_name
filter :activated

index do
	column :activated 
	column :company_name
	column "First", :first_name
	column "Last", :last_name
	column :email
	actions
end

show do
	columns do
		    column do
		      panel "Details" do
				attributes_table do
					row :activated
					row :company_name
					row :first_name
					row :last_name
					row :phone_number
					row :address1
					row :city
					row :state
					row :last_sign_in_at
					row :sign_in_count
				end 
			  end
			end   
			column do 
			  panel "Events" do
				table_for agency.events do
					column :name do |event|
						link_to event.name, admin_event_path(event)
					end	
					column :created_at
				end	
			  end 	
			end
		end	
	active_admin_comments
end	

# show do
#   panel "Patients" do
#     table_for physician.appointments do
#       column "name" do |appointment|
#         appointment.patient.name
#       end
#       column :appointment_date
#     end
#   end
# end

	permit_params :first_name, :last_name, :company_name, :email, :phone_number, :city, :state, :activated
	
	form do |f| 
		f.inputs "Agency" do
			f.input :activated
			f.input :company_name
			f.input :first_name
			f.input :last_name
			f.input :phone_number
			f.input :address1
			f.input :city
			f.input :state
		end	
		f.button "Save"
	end	
end

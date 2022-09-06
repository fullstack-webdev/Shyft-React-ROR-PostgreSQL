ActiveAdmin.register Ambassador do
	scope :all, default: true
	scope :notActivated
	scope :activated

	filter :first_name
	filter :last_name
	filter :activated

	before_filter :only => [:show, :edit] do
		@ambassador = Ambassador.friendly.find(params[:id])
	end

	index do
		column "Image" do |i|
			ul :style =>"list-style-type:none;" do

			i.images.first(1).each do |img|
				li do
				     link_to attachment_image_tag(img, :file, :fill, 50, 50), ambassador_path(i)
					end
				end

			end
		end
		column :activated
		column "First", :first_name
		column "Last", :last_name
		column :email
		column :email_confirmed
		column :phone_confirmed
		actions
	end

	show do
		attributes_table do
			ul :style =>"list-style-type:none;text-align:center;" do
				ambassador.images.each do |img|
				    li :style =>"display:inline;" do
				      	attachment_image_tag(img, :file, :fill, 200, 200)
					end
				end
			end
		end
		columns do
		    column do
		      panel "Details" do
				attributes_table do
					row "Profile" do |i|
									link_to "View Profile", ambassador_path(i)
								end
					row :first_name
					row :last_name
					row :full_name
					row :email
					row :rate do |ambassador|
						number_to_currency ambassador.rate
					end
					row :phone_number
					row :city
					row :state
					row :about
					row :activated
					row :phone_confirmed
					row :email_confirmed
					row :last_seen_at
					row :response_time
					row :acceptance_rate

          attributes_table "Properties" do
      			ul :style =>"list-style-type:none;text-align:center;" do
      				ambassador.properties.each do |property|
      				    li :style =>"display:list-item;" do
      				      Property.find(property.id).name
      					end
      				end
      			end
      		end
				end
			  end
			end
      column do
        panel "Roles" do
          attributes_table do
      			ul :style =>"list-style-type:none;text-align:center;" do
      				ambassador.ambassador_roles.each do |role|
      				    li :style =>"display:list-item;" do
      				      RoleType.find(role.role_type_id).displayname
      					end
      				end
      			end
      		end
        end
      end
			column do
				panel "Unavailability" do
					table_for ambassador do
						column do
							attributes_table do
							row "Monday" do
								ul :style =>"list-style-type:none;" do
									li :style =>"display:inline;" do
				       			 		ambassador.weekly_unavailability.monday_start.strftime("%H:%M")
									end
									li :style =>"display:inline;" do
										" -     to     - "
									end
				       				li :style =>"display:inline;" do
				       			 		ambassador.weekly_unavailability.monday_end.strftime("%H:%M")
									end
								end
							end
							row "Tuesday" do
								ul :style =>"list-style-type:none;" do
									li :style =>"display:inline;" do
				       			 		ambassador.weekly_unavailability.tuesday_start.strftime("%H:%M")
									end
									li :style =>"display:inline;" do
										" -     to     - "
									end
				       				li :style =>"display:inline;" do
				       			 		ambassador.weekly_unavailability.tuesday_end.strftime("%H:%M")
									end
								end
							end
							row "Wednesday" do
								ul :style =>"list-style-type:none;" do
									li :style =>"display:inline;" do
				       			 		ambassador.weekly_unavailability.wednesday_start.strftime("%H:%M")
									end
									li :style =>"display:inline;" do
										" -     to     - "
									end
				       				li :style =>"display:inline;" do
				       			 		ambassador.weekly_unavailability.wednesday_end.strftime("%H:%M")
									end
								end
							end
							row "Thursday" do
								ul :style =>"list-style-type:none;" do
									li :style =>"display:inline;" do
				       			 		ambassador.weekly_unavailability.thursday_start.strftime("%H:%M")
									end
									li :style =>"display:inline;" do
										" -     to     - "
									end
				       				li :style =>"display:inline;" do
				       			 		ambassador.weekly_unavailability.thursday_end.strftime("%H:%M")
									end
								end
							end
							row "Friday" do
								ul :style =>"list-style-type:none;" do
									li :style =>"display:inline;" do
				       			 		ambassador.weekly_unavailability.friday_start.strftime("%H:%M")
									end
									li :style =>"display:inline;" do
										" -     to     - "
									end
				       				li :style =>"display:inline;" do
				       			 		ambassador.weekly_unavailability.friday_end.strftime("%H:%M")
									end
								end
							end
							row "Saturday" do
								ul :style =>"list-style-type:none;" do
									li :style =>"display:inline;" do
				       			 		ambassador.weekly_unavailability.saturday_start.strftime("%H:%M")
									end
									li :style =>"display:inline;" do
										" -     to     - "
									end
				       				li :style =>"display:inline;" do
				       			 		ambassador.weekly_unavailability.saturday_end.strftime("%H:%M")
									end
								end
							end
							row "Sunday" do
								ul :style =>"list-style-type:none;" do
									li :style =>"display:inline;" do
				       			 		ambassador.weekly_unavailability.sunday_start.strftime("%H:%M")
									end
									li :style =>"display:inline;" do
										" -     to     - "
									end
				       				li :style =>"display:inline;" do
				       			 		ambassador.weekly_unavailability.sunday_end.strftime("%H:%M")
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


	permit_params :first_name, :last_name, :full_name, :email, :phone_number, :rate, :rate_currency, :city, :state, :phone_confirmed,
	:email_confirmed, :about, :last_seen_at, :response_time, :acceptance_rate, :roles, :activated, images_files: [],
	weekly_unavailability_attributes: [:sunday_start, :sunday_end, :monday_start, :monday_end, :tuesday_start, :tuesday_end, :wednesday_start, :wednesday_end, :thursday_start, :thursday_end, :friday_start, :friday_end, :saturday_start, :saturday_end],
  ambassador_roles_attributes: [:id, :ambassador_id, :role_type_id], property_ambassadors_attributes: [:id, :property_id, :ambassador_id]

	# index as: :grid do |product|
	#   link_to image_tag(product.image_path), admin_product_path(product)
	# end


		## WHen we want to add a drop down box http://activeadmin.info/docs/2-resource-customization.html

	form do |f|
		f.inputs "Delete Images" do
			ul :style => "text-align:center;"do
				 strong "Click on the images you want to delete, The page will not automatically refresh!"
				    br
				    br
				    f.object.images.each do |img|
				      	li :style =>"display:inline;" do
				  			link_to img, remote: true, label: :remove_image, method: :delete, data: {confirm: "Are you sure you want to delete this photo?"} do
				      			attachment_image_tag(img, :file, :fill, 200, 200)
				      		end
						end
					end
						li do
						f.attachment_field :images_files, multiple: true, presigned: true, direct: true, id: "imageinput", class: "dimmy", data: { disable_with: "Uploading photo..." }
					end

				end
			end
			columns do
		    column do
		      panel "Details" do
        		f.inputs "Ambassador" do
        			f.input :activated
        			f.input :first_name
        			f.input :last_name
        			f.input :email
        			f.input :rate do |ambassador|
        				number_to_currency ambassador.rate
        			end
      			f.input :phone_number
      			f.input :city
      			f.input :state
      			# f.input :about :style =>"size:24x10;"
      			f.input :about do |ambassador|
      				ambassador.about :style => "size:4x1;"
	          end
      			f.input :response_time
      			f.input :phone_confirmed
      			f.input :email_confirmed
          end

          f.inputs "Properties" do
            strong "Car = 1, Smart-Serve = 2, Food Handler Certificate = 3"
            f.has_many :property_ambassadors, allow_destroy: true do |t|
              t.input :property_id
              t.input :ambassador_id
            end
          end
        end
      end

    column do
      panel "Details" do
        f.inputs "Ambassador Roles" do
          strong "Ambassador = 1, Sampler = 2, Team Lead = 3, Bartender = 4, Promo Model = 5"
          f.has_many :ambassador_roles, allow_destroy: true do |t|
            t.input :role_type_id
            t.input :ambassador_id
          end
        end
        f.inputs "Weekly Unavailability" do
          f.has_many :weekly_unavailability, new_record: false do |item|
  	        item.input :sunday_start
  	        item.input :sunday_end
  	        item.input :monday_start
  	        item.input :monday_end
  	        item.input :tuesday_start
  	        item.input :tuesday_end
  	        item.input :wednesday_start
  	        item.input :wednesday_end
  	        item.input :thursday_start
  	        item.input :thursday_end
  	        item.input :friday_start
  	        item.input :friday_end
  	        item.input :saturday_start
  	        item.input :saturday_end
	        end
      	end
      end
    end
  end

  f.button "Save"
end
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


end

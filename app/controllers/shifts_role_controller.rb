class ShiftsRoleController < ApplicationController

  # NOTE: get all shifts by the date_id
  def roleStatusList
    render json: RoleStatus.all, status: 200
  end

  def roleTypes
    render json: RoleType.all, status: 200
  end

  # NOTE: get all shifts by the date_id
  def shiftsByDate
    # NOTE: required params[:date_id]
    @eventDate = EventDate.find_by_id(params[:date_id])
    # @shifts = @eventDate.event_date_shifts

    if @shifts = EventDateShift.where(event_date_id:params[:date_id])
      @sorted_shifts = @shifts.sort_by &:start_time
      render json: {event_date: @eventDate, shifts: @sorted_shifts}, status:200
    else
      render json: @event_date_shifts.errors, status: :unprocessable_entity
    end
  end

  # NOTE: get all roles by the shift_id
  def rolesByShift
    # NOTE: required params[:shift_id]

    @shift = EventDateShift.find_by_id(params[:shift_id])
    @role_statuses = RoleStatus.all
    @role_types = RoleType.all

    if @roles = EventRole.where('event_date_shift_id = ? and role_status != ? ', params[:shift_id], STATUS_CANCELLED).order(:id)
      data = []
      @roles.each { |role|
        role_type = @role_types.find {|s| s.id == role.role_type_id }
        role_status = @role_statuses.find {|s| s.status == role.role_status }

        ambassadorData = nil
        #Get ambassador details for role
        if role.role_status != 'empty'
          ambassador =  Ambassador.find(role.ambassador_id)
          out_images = images_for(ambassador)
          ambassadorData = {
              ambassador: ambassador,
              reviews: ambassador.reviews,
              shifts: [{:shift_id => role.event_date_shift_id, :roles => [role.id]}],
              images: out_images}
        end

        data.push({
          role: role,
          role_type: role_type,
          status: role_status.status,
          ambassador: ambassadorData
        })
      }
      render json: {roles: data}, status:200
    else
      render json: @roles.errors, status: :unprocessable_entity
    end
  end

  # NOTE: create a new shift based on the associated date
  def createShift
    # NOTE: required params[:date_id]
    @eventDate = EventDate.find_by_id(params[:date_id])
    startTimeDate = shift_params[:start_time].to_time
    endTimeDate = shift_params[:end_time].to_time

    event_year = @eventDate.event_date.year()
    event_month = @eventDate.event_date.month()
    event_day = @eventDate.event_date.day()

    p 'heroku server time'
    p "#{event_year}-#{event_month}-#{event_day}"
    startTimeDate = startTimeDate.change(year: event_year, month: event_month, day: event_day)
    endTimeDate = endTimeDate.change(year: event_year, month: event_month, day: event_day)

    # If the start time is greater than the end time
    # the end time should be pushed into the following day
    if startTimeDate > endTimeDate
      nextDay = @eventDate.event_date + 1
      event_year = nextDay.year()
      event_month = nextDay.month()
      event_day = nextDay.day()
      endTimeDate = endTimeDate.change(year: event_year, month: event_month, day: event_day)      
    end
    @newShift = @eventDate.event_date_shifts.new(start_time:startTimeDate, end_time:endTimeDate)

    if @newShift.save
      render json: {message: "Shift Created!", shift: @newShift}, status:200
    else
      render json: {errors: @newShift.errors.full_messages}
    end
  end

  # NOTE: create a role and attach it to a specific shift
  def createRoleForShift
    #
    # NOTE: required params[:shift_id]
    @shift = EventDateShift.find_by_id(params[:shift_id])

    # NOTE WHEN WE MOVE ALL THIS INTO SHORT LIST CONTROLLER
    # WE SHOULD DIRECTLY CREATE THE ROLE FROM THE EVENT TO AUTOMATICALLY ADD THE PROPER EVENT ID
    # FOR NOW WE MAKE UNNECESSARY QUERIES
    event_date = EventDate.find(@shift.event_date_id)
    event_location = EventLocation.find(event_date.event_location_id)
    @newRole = @shift.event_roles.new(role_params)
    @newRole.event_date_id = @shift.event_date_id
    @newRole.event_id = event_location.event_id

    if @newRole.save
      data = {
        role: @newRole,
        role_type:RoleType.find_by_id(@newRole.role_type_id),
        status: RoleStatus.find_by(:status => @newRole.role_status)
      }
      render json: {message: "Role Created!", data: data, shift_id: params[:shift_id]}, status:200
    else
      render json: {errors: @newRole.errors.full_messages}
    end
  end

  # NOTE: update and change the role for a specific shift
  def changeRoleForShift
    # NOTE: required params[:role_id]
    @role = EventRole.find_by_id(params[:role_id])

    if @role.update(role_params)
      data = {
        role: @role,
        role_type:RoleType.find_by_id(@role.role_type_id),
        status: RoleStatus.find_by(:status => @role.role_status)
      }
      render json: {message: "Role Updated!", data: data}, status:200
    else
      render json: {errors: @role.errors.full_messages}
    end
  end

  # NOTE: deletes the shift and the role associated with it
  def destroyShift
    # NOTE: required params[:shift_id]
    # NOTE: the shift is dependent on the "event_date" so it will be destroyed
    @shift = EventDateShift.find_by_id(params[:shift_id])
    if @shift.destroy
      render json: {data: @shift}, status:200
    else
      render json: @shift.errors, status: :unprocessable_entity
    end
  end

  def destroyRole
    # NOTE: required params[:role_id]
    @role = EventRole.find_by_id(params[:role_id])
    if @role.destroy
      render json: {data: @role}, status:200
    else
      render json: @role.errors, status: :unprocessible_entity
    end
  end

  def shortList
    # NOTE: required params[:role_ids] - Array of Strings, params[:ambassad_id]
    # NOTE: this should validate that the ambassador can fill this role_ids
    # NOTE: this should validate that the role can in fact be filled
    role_ids = params[:role_ids]
    ambassador_id = params[:ambassador_id]

    @roles = EventRole.where(id: role_ids)
    @roles.each do |role|
      @role = role
      rp = {'ambassador_id' => ambassador_id, 'role_status' => STATUS_SHORT_LIST}

      if !role.update(rp)
        render json: {errors: @role.errors.full_messages}
      end
    end

    render json: {message: "Ambassador was successfully shortListed."}, status:200
  end

  # NOTE: required params[:role_id] - Id of the EventRole
  def remove_ambassador_from_short_list
    role_id = params[:role_id]

    role = EventRole.find_by_id(role_id)
    role.ambassador_id = nil
    role.role_status = STATUS_EMPTY

    if role.save
      render json: {role: role}, status:200
    else
      render json: role.errors, status: :unprocessable_entity
    end
  end

  private
  def short_list_params
    params.require(:role_ids, :ambassador_id)
  end

  def shift_params
    params.require(:event_date_shift).permit(:start_time, :end_time)
  end

  def role_params
    params.require(:event_role).permit(:role_type_id, :hourly_rate, :role)
  end

  def images_for(ambassador)
    out_images = []
    ambassador.images.each do |image|
      out_image = image.attributes
      out_image['url'] = Refile.file_url(image.file, filename: 'profile')
      out_images << out_image
    end

    if ambassador.images.blank?
      out_images << {url: ActionController::Base.helpers.asset_path('shyft-d-profile.png')}
    end

    return out_images
  end
end

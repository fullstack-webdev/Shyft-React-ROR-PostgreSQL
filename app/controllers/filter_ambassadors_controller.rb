class FilterAmbassadorsController < ApplicationController

  before_action :init

  def init
    @wdayToDay = {0=>"sunday", 1=>"monday", 2=>"tuesday", 3=>"wednesday", 4=>"thursday", 5=>"friday", 6=>"saturday"}
    @days = {0=>nil, 1=>nil, 2=>nil, 3=>nil, 4=>nil, 5=>nil, 6=>nil}
  end

  def test

  end

  # NOTE Will be getting rid of this method
  # in the near future.
  # Requesting should always go through filter
  def filter_index
    filter
  end


  def filter
    days_to_check = []
    shifts_by_day = []

    if location_params?
      shifts_by_day = add_shift_ids_to_days
      shifts_by_day.each do |key, data|
        if !data.nil?
          days_to_check.push(key)
        end
      end
      @event_id = EventLocation.find_by_id(params[:location_id]).event_id
    end

    if days_to_check.length == 0 || shifts_by_day.length == 0
      return render json: {ambassadors: []}
    end

    @ambassadors = Ambassador.activated

    available_ambassadors = filter_for_shifts(days_to_check, shifts_by_day)
    available_ambassadors = available_ambassadors.sort_by {|data| data[:shifts].length}.reverse!

    render json: {ambassadors: available_ambassadors}
  end

  def fitler_by_role
    available_ambassadors = []
    data = []

    if params[:role_id]
      role = EventRole.find_by_id(params[:role_id])
      hourly_rate = BigDecimal.new(role.hourly_rate)
      ambassador_ids_by_role = AmbassadorRole.where(role_type_id: [role.role_type_id]).pluck(:ambassador_id).uniq
      data = Ambassador.activated.where(id: ambassador_ids_by_role).where('rate <= ?', hourly_rate)

      if !data.nil?
        data.each do |ambassador|
          shift = role.event_date_shift
          ambassador_available = ambassador.available_for_shifts_on_day([shift.id], @wdayToDay[shift.start_time.wday], role.event_id).length > 0

          if ambassador_available
            out_images = images_for(ambassador)

            available_ambassadors.push({
              ambassador: ambassador,
              properties: ambassador.properties,
              reviews: ambassador.reviews,
              shifts: [{:shift_id => role.event_date_shift_id, :roles => [role.id]}],
              images: out_images})
          end
        end
      end
    end

    render json: {ambassadors: available_ambassadors}
  end

  def short_listed_ambassadors
    bookedRoles = []
    data = []
    if params[:event_id]
      event_id = params[:event_id]
      # get shorte listed roles & ambassadors
      event_roles = EventRole.where('event_id = ? AND  role_status= ? AND ambassador_id > 0', event_id, 'short-list')
      event_roles.each do |role|
        ambassador =  Ambassador.find(role.ambassador_id)
        out_images = images_for(ambassador)
        ambassadorData = {
          ambassador: ambassador,
          reviews: ambassador.reviews,
          shifts: [{:shift_id => role.event_date_shift_id, :roles => [role.id]}],
          images: out_images
        }
        data.push(
          {
            role: role,
            ambassadorData: ambassador
          }
        )
      end
    end

    render json: {bookedAmbassadors: data}, status: 200
  end

  private

  def filter_for_shifts(days_to_check, shifts_by_day)
    available_ambassadors = []
    check_shifts = days_to_check.length > 0

    @ambassadors.each do |ambassador|
      available_ambassador = nil
      available_shifts = []

      if check_shifts
        available_shifts = available_shifts_for_ambassador(ambassador, days_to_check, shifts_by_day)
        available_ambassador = available_shifts.length > 0 ? ambassador : nil
      else
        available_ambassador = ambassador
      end

      if !available_ambassador.nil?
        out_images = images_for(ambassador)

        available_ambassadors.push({
          ambassador: available_ambassador,
          properties: available_ambassador.properties,
          reviews: available_ambassador.reviews,
          shifts: available_shifts,
          images: out_images})
      end
    end
    return available_ambassadors
  end

  # returns array of shift ids that the ambassador is available for
  def available_shifts_for_ambassador(ambassador, days_to_check, shifts_by_day)
    available_shifts = []

    days_to_check.each do |wday|
      # if the ambassador is available all day
      # they are available for all shifts on that day
      shiftsById = shifts_by_day[wday]["shifts"]
      shifts = ambassador.available_for_shifts_on_day(shiftsById, @wdayToDay[wday], @event_id)

      if shifts.length > 0
        available_shifts.push(shifts)
      end
    end
    # returns shifts ambassador is available for
    return available_shifts
  end

  def location_params?
    !params[:location_id].nil?
  end

  def role_params?
    !params[:role_ids].nil?
  end

  def ambassador_params
    params.require(:filter).permit(:price)
  end

  def add_shift_ids_to_days
    shifts_by_day = @days
    EventDate.where(event_location_id: params[:location_id]).includes(:event_date_shifts).find_each do |date|
      # iterate through all dates associated with the location
      day = shifts_by_day[date.event_date.wday]

      if day.nil?
        # add shifts object which is an array of event_date_shift id's
        shifts_by_day[date.event_date.wday] = {"shifts" => date.event_date_shifts.collect(&:id)}
      else
        # add id to shifts array
        shifts_by_day[date.event_date.wday]["shifts"].concat(date.event_date_shifts.collect(&:id))
      end
    end
    return shifts_by_day
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

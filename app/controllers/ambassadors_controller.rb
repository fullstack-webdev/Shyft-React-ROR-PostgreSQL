class AmbassadorsController < ApplicationController

  before_action :logged_in_ambassador,  only: [:edit, :update]
  before_action :correct_user,          only: [:edit, :update]
  helper_method :ambassador_conversation

  def disable_nav
    @disable_nav = false
  end

  def show
    @ambassador = Ambassador.friendly.find(params[:id])
  end

  def new
    @ambassador = Ambassador.new
  end

  def create
    @ambassador = Ambassador.new(ambassador_params)
    @ambassador.rate_currency = "CAD"
    @ambassador.rate = 14
    @ambassador.full_name = @ambassador.first_name + ' ' + @ambassador.last_name
    @ambassador.city = 'Toronto'
    @ambassador.state = 'Ontario'

    start_time = nil
    end_time = nil
    @ambassador.weekly_unavailability = WeeklyUnavailability.create!(
      sunday_start: start_time,
      sunday_end: end_time,
      monday_start: start_time,
      monday_end: end_time,
      tuesday_start: start_time,
      tuesday_end: end_time,
      wednesday_start: start_time,
      wednesday_end: end_time,
      thursday_start: start_time,
      thursday_end: end_time,
      friday_start: start_time,
      friday_end: end_time,
      saturday_start: start_time,
      saturday_end: end_time)

    if @ambassador.save
      @ambassador.send_activation_email
      create_ambassador_role(@ambassador.id)
      log_in @ambassador
      redirect_to edit_ambassador_path(@ambassador), :flash => {:success => "Thanks for requesting an account with Shyft! Before your account goes live and you can start accepting shifts we need to have a quick 15 min discovey call. We've sent you an email to schedule this call at <b>" + @ambassador.email + "</b>.
       ."}
    else
      flash.now[:danger] = 'Sorry, there was a problem creating your Ambassador Profile.  Please try again.'
      render 'new'
    end
  end

  def create_ambassador_role(id)
    # each ambassador should have default role of ambassador
    AmbassadorRole.create!(
        ambassador_id: id,
        role_type_id:1)
  end

  def edit
    if current_user.id == @ambassador.id
      @phone_number = PhoneNumber.new()
      @ambassador = Ambassador.friendly.find(params[:id])
      @images = @ambassador.images
    else
      redirect_to root_path, notice: "You do not have access"
    end
  end

  def update
    @ambassador = Ambassador.friendly.find(params[:id])
    a = params[:ambassador]
    a[:full_name] = a[:first_name] + " " + a[:last_name]

      # if params[:images_files]
      #   params[:images_files].each do |image|
      #     @ambassador.images_files.create(images_files: image)
      #   end
      # end

    # b = params[:ambassador]
    # b[:images_files] = b[:images_files] + @ambassador.images_files
     # b = @ambassador.images_files
    # new_images = params[:ambassador][:images_files]
    old_images = @ambassador.images_files

    ambassador_params[:images_files]= (params[:ambassador][:images_files] + old_images)
    # ambassador_params = ambassador_params << old_images
    # @ambassador.images_files = @ambassador.images_files.merge params[:ambassador][:images_files]
    # @ambassador.save
    # .merge images_files: params[:ambassador][:images_files]


    if @ambassador.update_attributes(ambassador_params)
      #
      # all_images = @ambassador.images_files + old_images
      # @ambassador.update_attributes(all_images)
      #
      redirect_to @ambassador, :flash => {:success => "Your profile has been updated."}
    else
      render 'edit'
    end
  end

  def index
    if current_agency
      redirect_to new_event_session_path, method: :get
      return
    end

    @criteria = {}

    if session[:search_criteria] != nil
      saved_criteria = session[:search_criteria]
      update_search_criteria
      @criteria[:start_time] = saved_criteria['start_time']
      @criteria[:end_time] = saved_criteria['end_time']
      @criteria[:event_date] = saved_criteria['event_date']
    end

    update_search_criteria

    @role_types = RoleType.all.pluck(:displayname, :type_of)
    # this is useless
    @search = Ambassador.search(activated: true)
    @ambassadors = Ambassador.activated
  end

    def ambassador_conversation
      if current_agency
        if Conversation.between(current_agency.id, @ambassador.id).present?
          @conversation = Conversation.between(current_agency.id, @ambassador.id).first
        else
          @conversation = Conversation.create(sender_id: current_agency.id, recipient_id: @ambassador.id)
        end
      end
    end

  private

    def ambassador_params
      params.require(:ambassador).permit(:first_name, :last_name, :full_name, :email, :password, :password_confirmation, :rate, :phone_number, :profile_image, :city, :state, :about, :tag_list, :tag_list, :remove_images_files, :remove_image, :monday, images_files: [], weekly_unavailability_attributes: [:sunday_start, :sunday_end, :monday_start, :monday_end, :tuesday_start, :tuesday_end, :wednesday_start, :wednesday_end, :thursday_start, :thursday_end, :friday_start, :friday_end, :saturday_start, :saturday_end])
    end

    # Confirms a logged in Ambassador
    def logged_in_ambassador
      unless logged_in?
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    # Confirms the correct Ambassador
    def correct_user
      @ambassador = Ambassador.friendly.find(params[:id])
      redirect_to(root_url) unless @ambassador == current_user
    end

    def update_search_criteria
      if params[:start_time]
        @criteria[:start_time] = params[:start_time]
      end

      if params[:end_time]
        @criteria[:end_time] = params[:end_time]
      end

      if params[:event_date]
        @criteria[:event_date] = params[:event_date]
      end

      session[:search_criteria] = @criteria
    end
end

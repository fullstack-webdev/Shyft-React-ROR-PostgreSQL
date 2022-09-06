class EventsController < ApplicationController
  before_action :authenticate_agency!
   # before_action :require_login, only: [:edit]

  def index
    session.delete(:event_id)

    @events = current_agency.events
    @agency_id = current_agency.id
    render :index
  end

  def new_event_session
    if session[:event_id]
        session.delete(:event_id)
     end

    redirect_to(:controller=>:events, :action=>:new)
  end

  def new
    #
    #not api
    @agency = current_agency

    if session[:event_id]
        # based on the event_id and the shifts tied to it
        @event = Event.find_by_id(session[:event_id])
        if @event.nil?
            session.delete(:event_id)
            @event = self.new_event(@agency.id)
        end
    else
        @event = self.new_event(@agency.id)
    end
  end

  def create
    #not api
    #
    @event = Event.new(event_params)
    if @event.save
            render json: @event
    else
        render json: @event.errors, status: :unprocessable_entity
    end
  end

  def show
    @event = Event.find(params[:event_id])
  end 

  def edit
    if params[:id]  && Event.where('id=?',params[:id]).length > 0
      if session[:event_id]
        session.delete(:event_id)
      end
      #we set seesione event_id 
      session[:event_id] = params[:id]
      #redirect_to(:controller=>:events, :action=>:new)
    else
      redirect_to(:controller=>:events, :action=>:index)
    end
  end

  def destroy
    Event.delete(params[:id])
    redirect_to events_path, flash => { success: "Event Deleted" }
  end

  def new_event(agency_id)
    event = Event.new
    event.name = ''
    event.event_details = ''
    event.agency_id = agency_id

    if event.save
      session[:event_id] = event.id
    end

    return event
  end

  private

  def event_params
    params.require(:event).permit(:agency_id, :name, :event_details, event_locations_attributes: [:id, :label, :address, :zip, :state, :country, :notes, event_dates_attributes: [:id, :event_date, event_roles_attributes: [:id, :role, :hourly_rate, :quantity]]])
  end
end

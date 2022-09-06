class BusyShiftController < ApplicationController
  def index
    #Example to get the Time part from UTC
      #current_user.busy_shifts.all.first.start_time.strftime("%I:%M%p")
      #returns -> "10:00AM"
      render json: {ambassador: current_user.full_name, busy_shifts: current_user.busy_shifts}
  end
  def new
    @busy_shift = BusyShift.new
  end
  
  # DANIEL: Rebuild this so it takes one busy shift at a time
    # The idea is to use AJAX to just immediately save a new busy_shift
  def create
    busy_shifts = params[:busy_shift]
    if busy_shifts
      busy_shifts[:day].length.times do |index|
        day = busy_shifts[:day][index]
        start_time  = busy_shifts[:start_time][index]
        end_time  = busy_shifts[:end_time][index]
        @busy_shifts = current_user.busy_shifts.create(:day => day, :start_time => start_time, :end_time => end_time)
      end
      render json: current_user.busy_shifts
    else
      render json: {errors: "Could not create busy shifts there was a error"}
    end
  end
  
  def edit
    @busy_shift = current_user.busy_shifts
  end
  
  # DANIEL: Update one shift at a time.
    # AJAX is a wonderful thing!
  def update
  end

  def destroy
    @busy_shift = BusyShift.find_by_id(params[:id])
    @busy_shift.destroy
    render json: {message: "Busy_shift successfully deleted"}, status: 200
  end

end

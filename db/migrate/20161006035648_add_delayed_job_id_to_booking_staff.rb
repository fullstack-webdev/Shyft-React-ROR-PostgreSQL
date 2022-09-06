class AddDelayedJobIdToBookingStaff < ActiveRecord::Migration
  def change
    add_column :booking_staffs, :delayed_job_id, :integer
  end
end

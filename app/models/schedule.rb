class Schedule < ApplicationRecord
  validates :user_id, :name, :start_time, :end_time, presence: true

  def create
    @schedule = Schedule.new(
                params.require(:schedule).permit(:name, :event, :start_time, :end_time)
                )
    @schedule.user_id = @current_user.id

    if @schedule.save
      return true
    else
      return 
    end
end

  def update
    @schedule = Schedule.find_by(id: params[:id])
    @schedule.start_time.in_time_zone("Tokyo")

    schedule_params = params.require(:schedule).permit(:name, :event, :start_time, :end_time)

    Rails.logger.debug "Schedule Params: #{schedule_params.inspect}"

    if @schedule.update(schedule_params)
      return true
    else
      return fl
    end
end
end

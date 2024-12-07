class RegularSchedule < ApplicationRecord
    validates :start_time, :finish_time, :name, :user_id, :number, presence: true

    def create_regularschedule_times(regularschedule)
        regularschedule.start_hour = regularschedule.start_time.strftime("%H").to_i
        regularschedule.start_minute = format("%02d", regularschedule.start_time.strftime("%M").to_i)
        regularschedule.finish_hour = regularschedule.finish_time.strftime("%H").to_i
        regularschedule.finish_minute = format("%02d", regularschedule.finish_time.strftime("%M").to_i)
    end
end

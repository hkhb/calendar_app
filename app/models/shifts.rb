class Shifts < ApplicationRecord
  validates :user_id, :number, :date, presence: true

  def create_schedule(shiftnumber, date)
    regularschedule = RegularSchedule.find_by(number: shiftnumber)

    if regularschedule

        start_hour = regularschedule.start_time.hour
        start_minute = regularschedule.start_time.min
        end_hour = regularschedule.finish_time.hour
        end_minute = regularschedule.finish_time.min

        start_time = date.in_time_zone + start_hour.hours + start_minute.minutes
        end_time = date.in_time_zone + (regularschedule.days - 1).days + end_hour.hours + end_minute.minutes

        Schedule.create!(user_id: current_user.id,
                        name: regularschedule.name,
                        event: regularschedule.event,
                        start_date: date,
                        finish_date: date + (regularschedule.days - 1).days,
                        start_time: start_time,
                        end_time: end_time,
                        number: shiftnumber
                        )
    end
end
end
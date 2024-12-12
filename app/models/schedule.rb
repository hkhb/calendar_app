class Schedule < ApplicationRecord
  validates :user_id, :name, :start_time, :end_time, presence: { message: "＊必須！" }

  def self.schedule_create(data, user)
    schedule = Schedule.new(data)
    schedule.user_id = user.id

    if schedule.save
      schedule.start_time
    else
      0
    end
  end

  def self.schedule_update(data, id)
    schedule = Schedule.find_by(id: id)

    if schedule.update(data)
      schedule.start_time
    else
      0
    end
  end
end

class RegularSchedule < ApplicationRecord

    validates :start_time, presence: true
    validates :finish_time, presence: true
    validates :name, presence: true
    validates :user_id, presence: true
    validates :number, presence: true
      
end

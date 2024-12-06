class Schedule < ApplicationRecord
  validates :user_id, :name, :start_time, :end_time, presence: true
end

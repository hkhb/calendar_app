class Shifts < ApplicationRecord
  validates :user_id, :number, :date, presence: true
end

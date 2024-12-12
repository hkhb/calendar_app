class Change2timeDatetimeToSchedules < ActiveRecord::Migration[7.2]
  def change
    change_column :schedules, :start_time, :datetime
    change_column :schedules, :finish_time, :datetime
  end
end

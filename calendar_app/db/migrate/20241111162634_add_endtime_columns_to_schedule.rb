class AddEndtimeColumnsToSchedule < ActiveRecord::Migration[7.2]
  def change
    add_column :schedules, :end_time, :datetime
  end
end

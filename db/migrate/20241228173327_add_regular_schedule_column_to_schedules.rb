class AddRegularScheduleColumnToSchedules < ActiveRecord::Migration[7.2]
  def change
    add_column :schedules, :regular_schedule, :boolean
  end
end

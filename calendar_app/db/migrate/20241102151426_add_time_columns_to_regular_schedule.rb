class AddTimeColumnsToRegularSchedule < ActiveRecord::Migration[7.2]
  def change
    add_column :regular_schedules, :start_hour, :integer
    add_column :regular_schedules, :start_minute, :integer
    add_column :regular_schedules, :finish_hour, :integer
    add_column :regular_schedules, :finish_minute, :integer
  end
end

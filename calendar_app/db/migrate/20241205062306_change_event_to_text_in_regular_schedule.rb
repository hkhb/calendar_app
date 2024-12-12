class ChangeEventToTextInRegularSchedule < ActiveRecord::Migration[7.2]
  def change
    change_column :regular_schedules, :event, :text
  end
end

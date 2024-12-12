class ChangeEventToTextInSchedule < ActiveRecord::Migration[7.2]
  def change
    change_column :schedules, :event, :text
  end
end

class AdduseridColumsToSchedule < ActiveRecord::Migration[7.2]
  def change
    add_column :schedules, :user_id, :integer
  end
end

class CreateSchedules < ActiveRecord::Migration[7.2]
  def change
    create_table :schedules do |t|
      t.string :name
      t.string :event
      t.date :start_date
      t.time :start_time
      t.date :finish_date
      t.time :finish_time

      t.timestamps
    end
  end
end

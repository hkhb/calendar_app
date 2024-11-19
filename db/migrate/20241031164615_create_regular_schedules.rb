class CreateRegularSchedules < ActiveRecord::Migration[7.2]
  def change
    create_table :regular_schedules do |t|
      t.string :name
      t.string :event
      t.integer :user_id
      t.integer :number
      t.time :start_time
      t.integer :days
      t.time :finish_time

      t.timestamps
    end
  end
end

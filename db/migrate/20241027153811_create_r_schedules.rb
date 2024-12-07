class CreateRSchedules < ActiveRecord::Migration[7.2]
  def change
    create_table :r_schedules do |t|
      t.string :name
      t.string :event
      t.integer :startnumber
      t.time :starttime
      t.integer :days
      t.time :finishtime

      t.timestamps
    end
  end
end

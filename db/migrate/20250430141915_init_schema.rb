class InitSchema < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest

      t.timestamps
    end

    create_table :schedules do |t|
      t.string :name
      t.text :event
      t.datetime :start_time
      t.date :start_date
      t.date :finish_date
      t.datetime :end_time
      t.integer :user_id
      t.integer :number
      t.boolean :regular_schedule

      t.timestamps
    end

    create_table :regular_schedules do |t|
      t.string :name
      t.text :event
      t.integer :user_id
      t.integer :number
      t.time :start_time
      t.integer :days
      t.time :finish_time

      t.timestamps
    end

    create_table :shifts do |t|
      t.date :date
      t.integer :number
      t.integer :user_id
      t.string :name

      t.timestamps
    end
  end
end

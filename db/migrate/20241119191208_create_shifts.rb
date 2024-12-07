class CreateShifts < ActiveRecord::Migration[7.2]
  def change
    create_table :shifts do |t|
      t.date :date
      t.integer :number
      t.integer :user_id

      t.timestamps
    end
  end
end

class AddregularscheduleTouserid < ActiveRecord::Migration[7.2]
  def change
    add_column :r_schedules, :user_id, :integer
  end
end

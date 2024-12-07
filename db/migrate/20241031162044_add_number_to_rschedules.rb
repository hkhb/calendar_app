class AddNumberToRschedules < ActiveRecord::Migration[7.2]
  def change
    add_column :r_schedules, :number, :integer
  end
end

class AddNumberColumusToschedule < ActiveRecord::Migration[7.2]
  def change
    add_column :schedules, :number, :integer 
  end
end

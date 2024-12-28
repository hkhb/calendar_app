class AddnameColumnToshifts < ActiveRecord::Migration[7.2]
  def change
    add_column :shifts, :name, :string
  end
end

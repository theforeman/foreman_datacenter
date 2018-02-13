class AddRacksizeToDevice < ActiveRecord::Migration[4.2]
  def change
    add_column :devices, :size, :integer, default: 1
  end
end

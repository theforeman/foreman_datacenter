class AddRacksizeToDevice < ActiveRecord::Migration
  def change
    add_column :devices, :size, :integer, default: 1
  end
end

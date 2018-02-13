class RemoveIndexFromDevices < ActiveRecord::Migration[4.2]
  def change
    remove_index :devices, :name
  end
end

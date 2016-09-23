class RemoveIndexFromDevices < ActiveRecord::Migration
  def change
    remove_index :devices, :name
  end
end

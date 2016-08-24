class ChangeDeviceTypes < ActiveRecord::Migration
  def change
    add_column :device_types, :width, :integer, limit: 2, default: 1
    add_column :device_types, :sections, :integer, limit: 2, default: 1
  end
end

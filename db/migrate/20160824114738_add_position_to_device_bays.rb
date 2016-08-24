class AddPositionToDeviceBays < ActiveRecord::Migration
  def change
    add_column :device_bays, :position_h, :integer, limit: 2, null: false
    add_column :device_bays, :position_v, :integer, limit: 2, null: false
  end
end

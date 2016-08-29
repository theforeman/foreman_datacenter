class AddIpAddressToDeviceInterfaces < ActiveRecord::Migration
  def change
    add_column :device_interfaces, :ip_address, :string, limit: 128, default: ''
  end
end

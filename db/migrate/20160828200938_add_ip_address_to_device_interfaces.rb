class AddIpAddressToDeviceInterfaces < ActiveRecord::Migration[4.2]
  def change
    add_column :device_interfaces, :ip_address, :string, limit: 128, default: ''
  end
end

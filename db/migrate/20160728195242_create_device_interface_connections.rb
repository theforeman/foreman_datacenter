class CreateDeviceInterfaceConnections < ActiveRecord::Migration
  def change
    create_table :device_interface_connections do |t|
      t.integer :interface_a
      t.integer :interface_b
      t.integer :connection_status, default: 0

      t.timestamps null: false
    end

    add_foreign_key :device_interface_connections, :device_interfaces,
                    column: :interface_a
    add_foreign_key :device_interface_connections, :device_interfaces,
                    column: :interface_b
  end
end

class CreateDeviceInterfaceConnections < ActiveRecord::Migration[4.2]
  def change
    create_table :device_interface_connections do |t|
      t.integer :interface_a
      t.integer :interface_b
      t.integer :connection_status, default: 0

      t.timestamps null: false
    end

    add_index :device_interface_connections, [:interface_a, :interface_b],
              unique: true, name: 'uniq_connection'
    add_foreign_key :device_interface_connections, :device_interfaces,
                    column: :interface_a, on_delete: :cascade
    add_foreign_key :device_interface_connections, :device_interfaces,
                    column: :interface_b, on_delete: :cascade
  end
end

class CreateForemanDatacenterInterfaceConnections < ActiveRecord::Migration
  def change
    create_table :foreman_datacenter_interface_connections do |t|
      t.integer :interface_a
      t.integer :interface_b
      t.integer :connection_status, default: 0

      t.timestamps null: false
    end

    add_foreign_key :foreman_datacenter_interface_connections,
                    :foreman_datacenter_interfaces, column: :interface_a
    add_foreign_key :foreman_datacenter_interface_connections,
                    :foreman_datacenter_interfaces, column: :interface_b
  end
end

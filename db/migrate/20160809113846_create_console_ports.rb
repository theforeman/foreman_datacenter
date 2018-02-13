class CreateConsolePorts < ActiveRecord::Migration[4.2]
  def change
    create_table :console_ports do |t|
      t.integer :device_id
      t.string :name, limit: 30
      t.integer :console_server_port_id, null: true
      t.integer :connection_status, default: 0

      t.timestamps null: false
    end

    add_foreign_key :console_ports, :devices, column: :device_id,
                    on_delete: :cascade
    add_foreign_key :console_ports, :console_server_ports,
                    column: :console_server_port_id, on_delete: :nullify
  end
end

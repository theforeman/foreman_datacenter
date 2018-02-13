class CreateConsoleServerPorts < ActiveRecord::Migration[4.2]
  def change
    create_table :console_server_ports do |t|
      t.integer :device_id
      t.string :name, limit: 30

      t.timestamps null: false
    end

    add_foreign_key :console_server_ports, :devices, column: :device_id,
                    on_delete: :cascade
  end
end

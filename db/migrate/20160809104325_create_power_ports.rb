class CreatePowerPorts < ActiveRecord::Migration[4.2]
  def change
    create_table :power_ports do |t|
      t.integer :device_id
      t.string :name, limit: 30
      t.integer :power_outlet_id, null: true
      t.integer :connection_status, default: 0

      t.timestamps null: false
    end

    add_foreign_key :power_ports, :devices, column: :device_id,
                    on_delete: :cascade
    add_foreign_key :power_ports, :power_outlets, column: :power_outlet_id,
                    on_delete: :nullify
  end
end

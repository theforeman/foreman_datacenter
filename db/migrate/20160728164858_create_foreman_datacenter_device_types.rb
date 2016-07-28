class CreateForemanDatacenterDeviceTypes < ActiveRecord::Migration
  def change
    create_table :foreman_datacenter_device_types do |t|
      t.integer :manufacturer_id
      t.string :model, limit: 50, null: false
      t.integer :u_height, limit: 2, default: 1
      t.boolean :is_full_depth, default: true
      t.boolean :is_console_server, default: false
      t.boolean :is_pdu, default: false
      t.boolean :is_network_device, default: true
      t.string :subdevice_role, limit: 10, default: 'None'

      t.timestamps null: false
    end

    add_foreign_key :foreman_datacenter_device_types,
                    :foreman_datacenter_manufacturers, column: :manufacturer_id
  end
end

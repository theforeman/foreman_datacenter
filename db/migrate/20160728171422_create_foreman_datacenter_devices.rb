class CreateForemanDatacenterDevices < ActiveRecord::Migration
  def change
    create_table :foreman_datacenter_devices do |t|
      t.integer :device_type_id
      t.integer :device_role_id
      t.integer :platform_id
      t.string :name, limit: 50, null: false
      t.string :serial, limit: 50, default: ''
      t.integer :rack_id
      t.integer :position, limit: 2, null: true
      t.integer :face, null: true
      t.integer :status, default: 0
      t.string :primary_ip4, default: ''
      t.string :primary_ip6, default: ''
      t.text :comments

      t.timestamps null: false
    end

    add_foreign_key :foreman_datacenter_devices,
                    :foreman_datacenter_device_types, column: :device_type_id
    add_foreign_key :foreman_datacenter_devices,
                    :foreman_datacenter_device_roles, column: :device_role_id
    add_foreign_key :foreman_datacenter_devices, :foreman_datacenter_platforms,
                    column: :platform_id
    add_foreign_key :foreman_datacenter_devices, :foreman_datacenter_racks,
                    column: :rack_id
    add_index :foreman_datacenter_devices, :name, unique: true
  end
end

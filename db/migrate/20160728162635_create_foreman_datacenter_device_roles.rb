class CreateForemanDatacenterDeviceRoles < ActiveRecord::Migration
  def change
    create_table :foreman_datacenter_device_roles do |t|
      t.string :name, limit: 50, null: false
      t.string :color, limit: 30, null: false

      t.timestamps null: false
    end

    add_index :foreman_datacenter_device_roles, :name, unique: true
  end
end

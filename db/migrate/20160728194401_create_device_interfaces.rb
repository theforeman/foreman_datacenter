class CreateDeviceInterfaces < ActiveRecord::Migration
  def change
    create_table :device_interfaces do |t|
      t.integer :device_id
      t.string :name, limit: 30
      t.string :form_factor
      t.string :mac_address, limit: 128, default: ''
      t.boolean :mgmt_only, default: false
      t.string :description, limit: 100

      t.timestamps null: false
    end

    add_foreign_key :device_interfaces, :devices, column: :device_id
  end
end

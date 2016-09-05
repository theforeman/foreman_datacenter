class CreateManagementDevices < ActiveRecord::Migration
  def change
    create_table :management_devices do |t|
      t.references :device
      t.string :name, null: false, limit: 255
      t.string :login
      t.string :password

      t.timestamps null: false
    end

    add_index :management_devices, :device_id
    add_foreign_key :management_devices, :devices, column: :device_id,
                    on_delete: :cascade
  end
end

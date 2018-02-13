class CreateDeviceModules < ActiveRecord::Migration[4.2]
  def change
    create_table :device_modules do |t|
      t.integer :device_id
      t.string :name, limit: 50, null: false
      t.string :part_id, limit: 50
      t.string :serial, limit: 50

      t.timestamps null: false
    end

    add_foreign_key :device_modules, :devices, column: :device_id,
                    on_delete: :cascade
  end
end

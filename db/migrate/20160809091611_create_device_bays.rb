class CreateDeviceBays < ActiveRecord::Migration[4.2]
  def change
    create_table :device_bays do |t|
      t.integer :device_id
      t.string :name, limit: 50
      t.integer :installed_device_id, null: true

      t.timestamps null: false
    end

    add_foreign_key :device_bays, :devices, column: :device_id,
                    on_delete: :cascade
    add_foreign_key :device_bays, :devices, column: :installed_device_id,
                    on_delete: :nullify
  end
end

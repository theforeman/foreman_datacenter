class CreatePowerOutlets < ActiveRecord::Migration
  def change
    create_table :power_outlets do |t|
      t.integer :device_id
      t.string :name, limit: 30

      t.timestamps null: false
    end

    add_foreign_key :power_outlets, :devices, column: :device_id,
                    on_delete: :cascade
  end
end

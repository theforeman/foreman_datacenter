class CreateDeviceBayTemplates < ActiveRecord::Migration[4.2]
  def change
    create_table :device_bay_templates do |t|
      t.integer :device_type_id
      t.string :name, limit: 30

      t.timestamps null: false
    end

    add_foreign_key :device_bay_templates, :device_types,
                    column: :device_type_id, on_delete: :cascade
  end
end

class CreateConsolePortTemplates < ActiveRecord::Migration
  def change
    create_table :console_port_templates do |t|
      t.integer :device_type_id
      t.string :name, limit: 30

      t.timestamps null: false
    end

    add_foreign_key :console_port_templates, :device_types,
                    column: :device_type_id, on_delete: :cascade
  end
end

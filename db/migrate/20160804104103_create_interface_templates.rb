class CreateInterfaceTemplates < ActiveRecord::Migration
  def change
    create_table :interface_templates do |t|
      t.integer :device_type_id
      t.string :name, limit: 30
      t.string :form_factor, default: '10GE (SFP+)'
      t.boolean :mgmt_only, default: false

      t.timestamps null: false
    end

    add_foreign_key :interface_templates, :device_types,
                    column: :device_type_id, on_delete: :cascade
  end
end

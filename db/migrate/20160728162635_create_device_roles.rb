class CreateDeviceRoles < ActiveRecord::Migration[4.2]
  def change
    create_table :device_roles do |t|
      t.string :name, limit: 50, null: false
      t.string :color, limit: 30, null: false

      t.timestamps null: false
    end

    add_index :device_roles, :name, unique: true
  end
end

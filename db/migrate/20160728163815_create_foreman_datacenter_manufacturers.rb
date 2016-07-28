class CreateForemanDatacenterManufacturers < ActiveRecord::Migration
  def change
    create_table :foreman_datacenter_manufacturers do |t|
      t.string :name, limit: 50, null: false

      t.timestamps null: false
    end


    add_index :foreman_datacenter_manufacturers, :name, unique: true
  end
end

class CreateForemanDatacenterRacks < ActiveRecord::Migration
  def change
    create_table :foreman_datacenter_racks do |t|
      t.integer :site_id
      t.integer :rack_group_id
      t.string :name, limit: 50
      t.string :facility_id, limit: 30, null: true
      t.integer :height, limit: 2
      t.text :comments

      t.timestamps null: false
    end

    add_foreign_key :foreman_datacenter_racks, :foreman_datacenter_sites,
                    column: :site_id
    add_foreign_key :foreman_datacenter_racks, :foreman_datacenter_rack_groups,
                    column: :rack_group_id
  end
end

class CreateForemanDatacenterRackGroups < ActiveRecord::Migration
  def change
    create_table :foreman_datacenter_rack_groups do |t|
      t.string :name, limit: 50
      t.integer :site_id

      t.timestamps null: false
    end

    add_foreign_key :foreman_datacenter_rack_groups, :foreman_datacenter_sites,
                    column: :site_id
  end
end

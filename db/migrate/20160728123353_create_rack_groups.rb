class CreateRackGroups < ActiveRecord::Migration[4.2]
  def change
    create_table :rack_groups do |t|
      t.string :name, limit: 50
      t.integer :site_id

      t.timestamps null: false
    end

    add_foreign_key :rack_groups, :sites, column: :site_id
  end
end

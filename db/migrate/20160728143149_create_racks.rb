class CreateRacks < ActiveRecord::Migration[4.2]
  def change
    create_table :racks do |t|
      t.integer :site_id
      t.integer :rack_group_id, null: true
      t.string :name, limit: 50
      t.string :facility_id, limit: 30, null: true
      t.integer :height, limit: 2
      t.text :comments

      t.timestamps null: false
    end

    add_foreign_key :racks, :sites, column: :site_id
  end
end

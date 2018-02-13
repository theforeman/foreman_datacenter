class CreateSites < ActiveRecord::Migration[4.2]
  def change
    create_table :sites do |t|
      t.string :name, limit: 50
      t.string :facility, limit: 50, default: ''
      t.integer :asn, length: 4, null: true
      t.string :physical_address, length: 200, default: ''
      t.string :shipping_address, length: 200, default: ''
      t.text :comments

      t.timestamps null: false
    end

    add_index :sites, :name, unique: true
  end
end

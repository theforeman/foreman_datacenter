class CreateManufacturers < ActiveRecord::Migration
  def change
    create_table :manufacturers do |t|
      t.string :name, limit: 50, null: false

      t.timestamps null: false
    end


    add_index :manufacturers, :name, unique: true
  end
end

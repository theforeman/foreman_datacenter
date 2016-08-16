class CreatePlatforms < ActiveRecord::Migration
  def change
    create_table :platforms do |t|
      t.string :name, limit: 50, null: false
      t.string :rpc_client, limit: 30, default: ''

      t.timestamps null: false
    end

    add_index :platforms, :name, unique: true
  end
end

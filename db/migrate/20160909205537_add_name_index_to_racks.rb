class AddNameIndexToRacks < ActiveRecord::Migration
  def change
    add_index :racks, :name
  end
end

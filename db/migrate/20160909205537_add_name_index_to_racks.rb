class AddNameIndexToRacks < ActiveRecord::Migration[4.2]
  def change
    add_index :racks, :name
  end
end

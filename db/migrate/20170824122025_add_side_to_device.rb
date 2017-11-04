class AddSideToDevice < ActiveRecord::Migration
  def change
    add_column :devices, :side, :integer, null: true
  end
end

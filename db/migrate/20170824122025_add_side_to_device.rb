class AddSideToDevice < ActiveRecord::Migration[4.2]
  def change
    add_column :devices, :side, :integer, null: true
  end
end

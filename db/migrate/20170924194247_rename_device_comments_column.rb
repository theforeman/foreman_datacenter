class RenameDeviceCommentsColumn < ActiveRecord::Migration[4.2]
  def change
    rename_column :devices, :comments, :old_comments
  end
end

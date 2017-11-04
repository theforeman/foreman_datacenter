class RenameDeviceCommentsColumn < ActiveRecord::Migration
  def change
    rename_column :devices, :comments, :old_comments
  end
end

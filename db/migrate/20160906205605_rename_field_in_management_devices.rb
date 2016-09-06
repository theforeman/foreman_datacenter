class RenameFieldInManagementDevices < ActiveRecord::Migration
  def change
    rename_column :management_devices, :name, :console_url
  end
end

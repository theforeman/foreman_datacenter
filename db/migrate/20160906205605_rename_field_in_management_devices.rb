class RenameFieldInManagementDevices < ActiveRecord::Migration[4.2]
  def change
    rename_column :management_devices, :name, :console_url
  end
end

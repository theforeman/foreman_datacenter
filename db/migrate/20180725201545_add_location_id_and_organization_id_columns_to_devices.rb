class AddLocationIdAndOrganizationIdColumnsToDevices < ActiveRecord::Migration[4.2]
  def change
    add_column :devices, :organization_id, :integer
    add_column :devices, :location_id, :integer
  end
end

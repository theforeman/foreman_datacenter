class AddLocationIdAndOrganizationIdColumnsToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :organization_id, :integer
    add_column :devices, :location_id, :integer
  end
end

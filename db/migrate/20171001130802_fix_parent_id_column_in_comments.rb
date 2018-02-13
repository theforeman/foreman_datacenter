class FixParentIdColumnInComments < ActiveRecord::Migration[4.2]
  def change
    change_column :datacenter_comments, :parent_id, :string
    rename_column :datacenter_comments, :parent_id, :ancestry
  end
end

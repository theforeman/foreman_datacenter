class RenamingComments < ActiveRecord::Migration[4.2]
  def change
    rename_table :comments, :datacenter_comments
  end
end

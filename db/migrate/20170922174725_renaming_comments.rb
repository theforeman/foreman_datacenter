class RenamingComments < ActiveRecord::Migration
  def change
    rename_table :comments, :datacenter_comments
  end
end

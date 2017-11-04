class AddUserIdToComments < ActiveRecord::Migration
  def change
    add_column :datacenter_comments, :user_id, :integer
  end
end

class AddUserIdToComments < ActiveRecord::Migration[4.2]
  def change
    add_column :datacenter_comments, :user_id, :integer
  end
end

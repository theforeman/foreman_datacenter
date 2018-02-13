class AddParentIdToComments < ActiveRecord::Migration[4.2]
  def change
    add_reference :datacenter_comments, :parent, index: true
  end
end

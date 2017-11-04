class AddParentIdToComments < ActiveRecord::Migration
  def change
    add_reference :datacenter_comments, :parent, index: true
  end
end

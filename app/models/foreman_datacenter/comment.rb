module ForemanDatacenter
  class Comment < ActiveRecord::Base
    self.table_name = "datacenter_comments"
    belongs_to :commentable, polymorphic: true  
    has_ancestry
    # belongs_to :parent, class_name: "ForemanDatacenter::Comment"
    # has_many :children, class_name: "ForemanDatacenter::Comment", foreign_key: "parent_id"
  end
end

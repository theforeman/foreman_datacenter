module ForemanDatacenter
  class Comment < ActiveRecord::Base
    self.table_name = "datacenter_comments"
    belongs_to :commentable, polymorphic: true  
  end
end

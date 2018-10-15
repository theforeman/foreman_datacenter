module ForemanDatacenter
  class Comment < ActiveRecord::Base
    self.table_name = "datacenter_comments"
    belongs_to :commentable, polymorphic: true  
    belongs_to :user
    has_ancestry

    validates :content, presence: true
  end
end

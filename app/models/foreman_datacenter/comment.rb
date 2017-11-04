module ForemanDatacenter
  class Comment < ActiveRecord::Base
    belongs_to :commentable, polymorphic: true  
  end
end

module ForemanDatacenter
  class RackGroup < ActiveRecord::Base
    belongs_to :site, :class_name => 'ForemanDatacenter::Site'
  end
end

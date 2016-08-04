module ForemanDatacenter
  class PowerPortTemplate < ActiveRecord::Base
    belongs_to :device_type, :class_name => 'ForemanDatacenter::DeviceType'
  end
end

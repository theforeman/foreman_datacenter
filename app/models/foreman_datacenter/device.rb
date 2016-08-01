module ForemanDatacenter
  class Device < ActiveRecord::Base
    belongs_to :device_type, :class_name => 'ForemanDatacenter::DeviceType'
    belongs_to :device_role, :class_name => 'ForemanDatacenter::DeviceRole'
    belongs_to :platform, :class_name => 'ForemanDatacenter::Platform'
    belongs_to :rack, :class_name => 'ForemanDatacenter::Rack'
  end
end

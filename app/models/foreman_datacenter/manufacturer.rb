module ForemanDatacenter
  class Manufacturer < ActiveRecord::Base
    has_many :device_types, :class_name => 'ForemanDatacenter::DeviceType'
  end
end

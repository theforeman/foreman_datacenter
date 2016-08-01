module ForemanDatacenter
  class DeviceType < ActiveRecord::Base
    belongs_to :manufacturer, :class_name => 'ForemanDatacenter::Manufacturer'
    has_many :devices, :class_name => 'ForemanDatacenter::Device'
  end
end

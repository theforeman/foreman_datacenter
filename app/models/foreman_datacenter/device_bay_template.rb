module ForemanDatacenter
  class DeviceBayTemplate < ActiveRecord::Base
    belongs_to :device_type, :class_name => 'ForemanDatacenter::DeviceType'

    validates :device_type_id, presence: true
    validates :name, presence: true, length: { maximum: 30 }
  end
end

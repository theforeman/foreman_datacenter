module ForemanDatacenter
  class DeviceModule < ActiveRecord::Base
    belongs_to :device, :class_name => 'ForemanDatacenter::Device'

    validates :device_id, presence: true
    validates :name, presence: true, length: { maximum: 50 }
    validates :part_id, length: { maximum: 50 }
    validates :serial, length: { maximum: 50 }
  end
end

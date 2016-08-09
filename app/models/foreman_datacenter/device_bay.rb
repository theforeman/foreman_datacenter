module ForemanDatacenter
  class DeviceBay < ActiveRecord::Base
    belongs_to :device, :class_name => 'ForemanDatacenter::Device'
    belongs_to :installed_device, :class_name => 'ForemanDatacenter::Device'

    validates :name, presence: true, length: { maximum: 50 }
    validates :device_id, presence: true
  end
end

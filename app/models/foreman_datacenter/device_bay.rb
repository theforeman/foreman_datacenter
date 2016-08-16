module ForemanDatacenter
  class DeviceBay < ActiveRecord::Base
    belongs_to :device, :class_name => 'ForemanDatacenter::Device'
    belongs_to :installed_device, :class_name => 'ForemanDatacenter::Device'

    validates :name, presence: true, length: {maximum: 50}
    validates :device_id, presence: true

    def available_child_devices
      Device.joins(:device_type).
        joins('LEFT JOIN device_bays ON devices.id = device_bays.installed_device_id').
        where(['device_types.subdevice_role = ? AND devices.rack_id = ? AND device_bays.id IS NULL', 'Child', device.rack_id])
    end
  end
end

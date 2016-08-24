module ForemanDatacenter
  class DeviceBay < ActiveRecord::Base
    belongs_to :device, :class_name => 'ForemanDatacenter::Device'
    belongs_to :installed_device, :class_name => 'ForemanDatacenter::Device'

    validates :name, presence: true, length: {maximum: 50}
    validates :device_id, presence: true
    validate :must_have_correct_position

    def available_child_devices
      Device.joins(:device_type).
        joins('LEFT JOIN device_bays ON devices.id = device_bays.installed_device_id').
        where(['device_types.subdevice_role = ? AND devices.rack_id = ? AND device_bays.id IS NULL', 'Child', device.rack_id])
    end

    private

    def must_have_correct_position
      if device
        unless device.position_exists?(position_h, position_v)
          errors.add(:position_h, 'Specified position does not exist')
          errors.add(:position_v, 'Specified position does not exist')
        end
        if device.has_device_bay_at?(position_h, position_v)
          errors.add(:position_h, 'This position is already occupied')
          errors.add(:position_v, 'This position is already occupied')
        end
      end
    end
  end
end

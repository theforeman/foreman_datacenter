module ForemanDatacenter
  class DeviceRole < ActiveRecord::Base
    COLORS = [
        'Teal', 'Green', 'Blue', 'Purple', 'Yellow', 'Orange', 'Red',
        'Light Gray', 'Medium Gray', 'Dark Gray'
    ].freeze

    has_many :devices, :class_name => 'ForemanDatacenter::Device'
  end
end

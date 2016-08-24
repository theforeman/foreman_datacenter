module ForemanDatacenter
  module HostExtensions
    extend ActiveSupport::Concern

    included do
      has_one :device, class_name: 'ForemanDatacenter::Device',
              foreign_key: 'host_id', dependent: :nullify
      after_destroy :update_device_on_destroy
    end

    def update_device_on_destroy
      new_device_name = "Unassigned device (former: #{name})"
      device.update(name: new_device_name)
    end
  end
end

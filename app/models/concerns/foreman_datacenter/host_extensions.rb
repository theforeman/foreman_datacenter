module ForemanDatacenter
  module HostExtensions
    extend ActiveSupport::Concern

    included do
      has_one :device, class_name: 'ForemanDatacenter::Device',
              foreign_key: 'host_id', dependent: :nullify
      after_destroy :update_device_on_destroy
    end

    def update_device_on_destroy
      if device 
        new_device_name = "Unassigned device (former: #{name})"
        device.update(name: new_device_name)
        # device.interfaces.clear
      end
    end

    def fact_value_by_name(name)
      fact_name = FactName.find_by(name: name)
      if fact_name
        fact_values.find_by(fact_name: fact_name)
      end
    end
  end
end

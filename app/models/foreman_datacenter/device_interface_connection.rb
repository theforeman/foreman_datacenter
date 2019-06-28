module ForemanDatacenter
  class DeviceInterfaceConnection < ActiveRecord::Base
    include ScopedSearchExtensions
    include Authorizable

    belongs_to :first_interface, class_name: 'ForemanDatacenter::DeviceInterface',
               foreign_key: 'interface_a'
    belongs_to :second_interface, class_name: 'ForemanDatacenter::DeviceInterface',
               foreign_key: 'interface_b'

    enum connection_status: [:connected, :planned]

    validates :interface_a, presence: true
    validates :interface_b, presence: true

    validate do
      if interface_a == interface_b
        errors.add(:interface_b, 'Cannot connect an interface to itself')
      end
    end

    scoped_search in: :first_interface, on: :name, complete_value: true, rename: :interface_a
    scoped_search in: :second_interface, on: :name, complete_value: true, rename: :interface_b

    def first_device
      first_interface.device
    end

    def first_rack
      first_device.rack
    end

    def first_site
      first_rack.site
    end

    def second_device
      second_interface.device
    end

    def second_rack
      second_device.rack
    end

    def second_site
      second_rack.site
    end
  end
end

module ForemanDatacenter
  class DeviceType < ActiveRecord::Base
    SUBDEVICE_ROLES = ['None', 'Parent', 'Child'].freeze

    belongs_to :manufacturer, :class_name => 'ForemanDatacenter::Manufacturer'
    has_many :devices, :class_name => 'ForemanDatacenter::Device'
    has_many :interface_templates, :class_name => 'ForemanDatacenter::InterfaceTemplate'
    has_many :console_port_templates, :class_name => 'ForemanDatacenter::ConsolePortTemplate'
    has_many :power_port_templates, :class_name => 'ForemanDatacenter::PowerPortTemplate'
    has_many :console_server_port_templates, :class_name => 'ForemanDatacenter::ConsoleServerPortTemplate'
    has_many :power_outlet_templates, :class_name => 'ForemanDatacenter::PowerOutletTemplate'
    has_many :device_bay_templates, :class_name => 'ForemanDatacenter::DeviceBayTemplate'

    validates :manufacturer_id, presence: true
    validates :model, presence: true, length: { maximum: 50 }
    validates :u_height, numericality: { only_integer: true }
    validates :subdevice_role, inclusion: { in: SUBDEVICE_ROLES },
              allow_blank: true

    def parent?
      subdevice_role == 'Parent'
    end

    def child?
      subdevice_role == 'Child'
    end

    def network_interfaces
      interface_templates.reject(&:mgmt_only)
    end

    def management_interfaces
      interface_templates.select(&:mgmt_only)
    end
  end
end

module ForemanDatacenter
  class Device < ActiveRecord::Base
    belongs_to :device_type, :class_name => 'ForemanDatacenter::DeviceType'
    belongs_to :device_role, :class_name => 'ForemanDatacenter::DeviceRole'
    belongs_to :platform, :class_name => 'ForemanDatacenter::Platform'
    belongs_to :rack, :class_name => 'ForemanDatacenter::Rack'
    has_many :device_bays, :class_name => 'ForemanDatacenter::DeviceBay'
    has_one :parent_device_bay, :class_name => 'ForemanDatacenter::DeviceBay',
            :foreign_key => 'installed_device_id'
    has_many :power_outlets, :class_name => 'ForemanDatacenter::PowerOutlet'
    has_many :power_ports, :class_name => 'ForemanDatacenter::PowerPort'
    has_many :console_server_ports, :class_name => 'ForemanDatacenter::ConsoleServerPort'
    has_many :console_ports, :class_name => 'ForemanDatacenter::ConsolePort'
    has_many :interfaces, :class_name => 'ForemanDatacenter::DeviceInterface'
    has_many :management_interfaces, -> { where(mgmt_only: true) },
             :class_name => 'ForemanDatacenter::DeviceInterface'
    has_many :non_management_interfaces, -> { where(mgmt_only: false) },
             :class_name => 'ForemanDatacenter::DeviceInterface'
    has_many :modules, :class_name => 'ForemanDatacenter::DeviceModule'

    enum face: [:front, :rear]
    enum status: [:active, :offline]

    validates :device_type_id, presence: true
    validates :device_role_id, presence: true
    validates :name, presence: true, uniqueness: true, length: { maximum: 50 }
    validates :serial, length: { maximum: 50 }
    validates :rack_id, presence: true
    validates :position, numericality: { only_integer: true }, allow_nil: true

    after_create :create_interfaces
    after_create :create_console_ports
    after_create :create_power_ports
    after_create :create_console_server_ports
    after_create :create_power_outlets
    after_create :create_device_bays

    def site_id
      rack.try(:site_id)
    end

    def site
      rack.site
    end

    def ip_address
      primary_ip4 || primary_ip6
    end

    def manufacturer_id
      device_type.try(:manufacturer_id)
    end

    def is_console_server
      device_type.try(:is_console_server)
    end

    def is_pdu
      device_type.try(:is_pdu)
    end

    def is_network_device
      device_type.try(:is_network_device)
    end

    def parent?
      device_type.try(:subdevice_role) == 'Parent'
    end

    def free_interfaces
      interfaces.where(mgmt_only: false).reject(&:connected?)
    end

    def free_console_ports
      console_ports.where(console_server_port_id: nil)
    end

    def free_power_ports
      power_ports.where(power_outlet_id: nil)
    end

    def free_console_server_ports
      console_server_ports.joins('LEFT JOIN console_ports ON console_server_ports.id = console_ports.console_server_port_id').
        where(console_ports: { console_server_port_id: nil })
    end

    def free_power_outlets
      power_outlets.joins('LEFT JOIN power_ports ON power_outlets.id = power_ports.power_outlet_id').
        where(power_ports: { power_outlet_id: nil })
    end

    protected

    def create_interfaces
      device_type.interface_templates.each do |template|
        interfaces.create(template.attrs_to_copy)
      end
    end

    def create_console_ports
      device_type.console_port_templates.each do |template|
        console_ports.create(template.attrs_to_copy)
      end
    end

    def create_power_ports
      device_type.power_port_templates.each do |template|
        power_ports.create(template.attrs_to_copy)
      end
    end

    def create_console_server_ports
      if device_type.is_console_server?
        device_type.console_server_port_templates.each do |template|
          console_server_ports.create(template.attrs_to_copy)
        end
      end
    end

    def create_power_outlets
      if device_type.is_pdu?
        device_type.power_outlet_templates.each do |template|
          power_outlets.create(template.attrs_to_copy)
        end
      end
    end

    def create_device_bays
      if device_type.parent?
        device_type.device_bay_templates.each do |template|
          device_bays.create(template.attrs_to_copy)
        end
      end
    end
  end
end

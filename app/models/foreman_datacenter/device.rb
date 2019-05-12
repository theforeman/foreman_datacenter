module ForemanDatacenter
  class Device < ActiveRecord::Base
    include ScopedSearchExtensions

    belongs_to :device_type, class_name: 'ForemanDatacenter::DeviceType'
    belongs_to :device_role, class_name: 'ForemanDatacenter::DeviceRole'
    belongs_to :platform, class_name: 'ForemanDatacenter::Platform'
    belongs_to :rack, class_name: 'ForemanDatacenter::Rack'
    has_many :device_bays, class_name: 'ForemanDatacenter::DeviceBay', dependent: :destroy
    has_one :parent_device_bay, class_name: 'ForemanDatacenter::DeviceBay', foreign_key: 'installed_device_id'#, dependent: :destroy
    has_many :power_outlets, class_name: 'ForemanDatacenter::PowerOutlet', dependent: :destroy
    has_many :power_ports, class_name: 'ForemanDatacenter::PowerPort', dependent: :destroy
    has_many :console_server_ports, class_name: 'ForemanDatacenter::ConsoleServerPort', dependent: :destroy
    has_many :console_ports, class_name: 'ForemanDatacenter::ConsolePort', dependent: :destroy
    has_many :interfaces, class_name: 'ForemanDatacenter::DeviceInterface', dependent: :destroy
    has_many :management_interfaces, -> { where(mgmt_only: true) }, class_name: 'ForemanDatacenter::DeviceInterface', dependent: :destroy
    has_many :non_management_interfaces, -> { where(mgmt_only: false) }, class_name: 'ForemanDatacenter::DeviceInterface', dependent: :destroy
    has_many :modules, class_name: 'ForemanDatacenter::DeviceModule', dependent: :destroy
    has_one :ipmi_interface, -> { where(name: 'ipmi', mgmt_only: true) }, class_name: 'ForemanDatacenter::DeviceInterface', dependent: :destroy
    has_one :mgmt_interface, -> { where(name: 'mgmt', mgmt_only: true) }, class_name: 'ForemanDatacenter::DeviceInterface', dependent: :destroy
    belongs_to_host
    has_one :management_device, class_name: 'ForemanDatacenter::ManagementDevice', dependent: :destroy
    has_one :site, through: :rack

    has_many :comments, class_name: 'ForemanDatacenter::Comment', dependent: :destroy, as: :commentable

    enum face: [:front, :rear]
    enum side: [:left, :right, :full]
    enum status: [:active, :offline]

    validates :device_type_id, presence: true
    validates :device_role_id, presence: true
    validates :name, presence: true, length: { maximum: 50 }
    validates :serial, length: { maximum: 50 }
    validates :rack_id, presence: true
    validates :position, numericality: { only_integer: true }, allow_nil: true

    after_create :create_interfaces
    after_create :import_interfaces_from_host
    after_create :create_console_ports
    after_create :create_power_ports
    after_create :create_console_server_ports
    after_create :create_power_outlets
    after_create :create_device_bays

    scoped_search on: :name, complete_value: true, default_order: true
    scoped_search on: :status, complete_value: { active: 0, offline: 1 },
                  default_order: true
    scoped_search in: :site, on: :name, complete_value: true, rename: :site
    scoped_search in: :rack, on: :name, complete_value: true, rename: :rack
    scoped_search in: :device_role, on: :name, complete_value: true, rename: :role
    scoped_search in: :device_type, on: :model, complete_value: true, rename: :type
    scoped_search in: :platform, on: :name, complete_value: true, rename: :platform
    scoped_search in: :comments, on: :content, complete_value: true, rename: :comments

    delegate :site_id, to: :rack, allow_nil: true
    delegate :manufacturer_id, :is_console_server, :is_pdu, :is_network_device,
             to: :device_type, allow_nil: true
    delegate :console_url, :login, :password, to: :management_device
    delegate :hostname, to: :host, allow_nil: true

    def mac_address
      ipmi_interface.try(:mac_address) || mgmt_interface.try(:mac_address)
    end

    def ip_address
      ipmi_interface.try(:ip_address) || mgmt_interface.try(:ip_address) ||
        primary_ip4
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

    def populate_from_host(host)
      self.host = host
      self.name = host.name

      device_type = DeviceType.for_host(host)
      self.device_type = device_type if device_type

      self.device_role = DeviceRole.for_host unless self.device_role

      serial = host.fact_value_by_name('serialnumber')
      self.serial = serial.value if serial
    end

    def name_without_fqdn
      match = name.match(/^([^.]*)/)
      match[1] if match
    end

    def positions
      result = []
      if size.nil?
        result << position
      else
        size.times{ |p| result << (position + p) } unless position.nil?
      end
      return result
    end

    def sync_interfaces_with_host
      if host
        existed_names = interfaces.map(&:name)
        host.interfaces.each do |interface|
          unless existed_names.include?(interface.identifier)
            interfaces.create(
              name: interface.identifier,
              form_factor: ForemanDatacenter::DeviceInterface::DEFAULT_FORM_FACTOR,
              mac_address: interface.mac,
              ip_address: interface.ip,
              mgmt_only: interface.identifier == 'ipmi'
            )
          end
        end
      end
    end

    private

    def create_interfaces
      device_type.interface_templates.each do |template|
        interfaces.create(template.attrs_to_copy)
      end
    end

    def import_interfaces_from_host
      if host
        host.interfaces.each do |interface|
          interfaces.create(
            name: interface.identifier,
            form_factor: ForemanDatacenter::DeviceInterface::DEFAULT_FORM_FACTOR,
            mac_address: interface.mac,
            ip_address: interface.ip,
            mgmt_only: interface.identifier == 'ipmi'
          )
        end
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

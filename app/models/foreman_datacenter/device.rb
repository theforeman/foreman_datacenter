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

    enum face: [:front, :rear]
    enum status: [:active, :offline]

    validates :device_type_id, presence: true
    validates :device_role_id, presence: true
    validates :name, presence: true, uniqueness: true, length: {maximum: 50}
    validates :serial, length: {maximum: 50}
    validates :rack_id, presence: true
    validates :position, numericality: {only_integer: true}, allow_nil: true

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
  end
end

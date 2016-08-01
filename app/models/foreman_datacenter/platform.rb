module ForemanDatacenter
  class Platform < ActiveRecord::Base
    RPC_CLIENTS = [
        'Juniper Junos (NETCONF)',
        'Cisco IOS (SSH)',
        'Opengear (SSH)'
    ].freeze

    has_many :devices, :class_name => 'ForemanDatacenter::Device'
  end
end

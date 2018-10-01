module ForemanDatacenter
  class Platform < ActiveRecord::Base
    include ScopedSearchExtensions
    include Authorizable

    RPC_CLIENTS = [
        'Juniper Junos (NETCONF)',
        'Cisco IOS (SSH)',
        'Opengear (SSH)'
    ].freeze

    has_many :devices, :class_name => 'ForemanDatacenter::Device'

    validates :name, presence: true, uniqueness: true, length: { maximum: 50 }
    validates :rpc_client, length: { maximum: 30 },
              inclusion: { in: RPC_CLIENTS, message: "RPC client must be one of: #{RPC_CLIENTS.join(', ')}" },
              allow_blank: true

    scoped_search on: :name, complete_value: true, default_order: true
  end
end

module ForemanDatacenter
  class ConsolePort < ActiveRecord::Base
    include ScopedSearchExtensions
    include Authorizable

    belongs_to :device, :class_name => 'ForemanDatacenter::Device'
    belongs_to :console_server_port, :class_name => 'ForemanDatacenter::ConsoleServerPort'

    enum connection_status: [:connected, :planned]

    validates :device_id, presence: true
    validates :name, presence: true, length: { maximum: 30 }

    scoped_search on: :name, complete_value: true, default_order: true, rename: :console_port
    scoped_search on: :connection_status, default_order: true, complete_value: {connected: 0, planned: 1}
    scoped_search in: :device, on: :name, complete_value: true, rename: :device
    scoped_search in: :console_server_port, on: :name, complete_value: true, rename: :port
    scoped_search on: :created_at, complete_value: true, default_order: true
    scoped_search on: :updated_at, complete_value: true, default_order: true

    def connect(port, connection_status)
      update(console_server_port: port, connection_status: connection_status)
    end

    def disconnect
      update(console_server_port: nil)
    end
  end
end

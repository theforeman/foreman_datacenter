module ForemanDatacenter
  class PowerPort < ActiveRecord::Base
    include ScopedSearchExtensions
    include Authorizable

    belongs_to :device, :class_name => 'ForemanDatacenter::Device'
    belongs_to :power_outlet, :class_name => 'ForemanDatacenter::PowerOutlet'

    enum connection_status: [:connected, :planned]

    validates :device_id, presence: true
    validates :name, presence: true, length: { maximum: 30 }

    scoped_search on: :name, complete_value: true, default_order: true, rename: :power_port
    scoped_search on: :connection_status, default_order: true, complete_value: {connected: 0, planned: 1}
    scoped_search in: :device, on: :name, complete_value: true, rename: :device
    scoped_search in: :power_outlet, on: :name, complete_value: true, rename: :outlet
    scoped_search on: :created_at, complete_value: true, default_order: true
    scoped_search on: :updated_at, complete_value: true, default_order: true

    def connect(outlet, connection_status)
      update(power_outlet: outlet, connection_status: connection_status)
    end

    def disconnect
      update(power_outlet_id: nil)
    end
  end
end

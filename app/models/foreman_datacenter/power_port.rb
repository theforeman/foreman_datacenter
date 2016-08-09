module ForemanDatacenter
  class PowerPort < ActiveRecord::Base
    belongs_to :device, :class_name => 'ForemanDatacenter::Device'
    belongs_to :power_outlet, :class_name => 'ForemanDatacenter::PowerOutlet'

    enum connection_status: [:connected, :planned]

    validates :device_id, presence: true
    validates :name, presence: true, length: { maximum: 30 }
  end
end

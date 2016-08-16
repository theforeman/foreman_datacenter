module ForemanDatacenter
  class PowerOutlet < ActiveRecord::Base
    belongs_to :device, :class_name => 'ForemanDatacenter::Device'
    has_one :power_port, :class_name => 'ForemanDatacenter::PowerPort'

    validates :device_id, presence: true
    validates :name, presence: true, length: { maximum: 30 }
  end
end

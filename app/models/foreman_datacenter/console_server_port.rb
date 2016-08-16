module ForemanDatacenter
  class ConsoleServerPort < ActiveRecord::Base
    belongs_to :device, :class_name => 'ForemanDatacenter::Device'
    has_one :console_port, :class_name => 'ForemanDatacenter::ConsolePort'

    validates :device_id, presence: true
    validates :name, presence: true, length: { maximum: 30 }
  end
end

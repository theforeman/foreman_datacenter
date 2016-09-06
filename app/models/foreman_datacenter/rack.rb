module ForemanDatacenter
  class Rack < ActiveRecord::Base
    belongs_to :site, :class_name => 'ForemanDatacenter::Site'
    belongs_to :rack_group, :class_name => 'ForemanDatacenter::RackGroup'
    has_many :devices, :class_name => 'ForemanDatacenter::Device'

    validates :site_id, presence: true
    validates :name, presence: true, length: { maximum: 50 }
    validates :facility_id, length: { maximum: 30 }
    validates :height, presence: true
    validates_numericality_of :height, only_integer: true

    def device_at(position)
      devices.find { |d| d.position == position }
    end

    def positioned_devices
      height.downto(1).map { |position| [position, device_at(position)] }
    end
  end
end

module ForemanDatacenter
  class Device < ActiveRecord::Base
    belongs_to :device_type, :class_name => 'ForemanDatacenter::DeviceType'
    belongs_to :device_role, :class_name => 'ForemanDatacenter::DeviceRole'
    belongs_to :platform, :class_name => 'ForemanDatacenter::Platform'
    belongs_to :rack, :class_name => 'ForemanDatacenter::Rack'

    enum face: [:front, :rear]
    enum status: [:active, :offline]

    validates :device_type_id, presence: true
    validates :device_role_id, presence: true
    validates :name, presence: true, uniqueness: true, length: { maximum: 50 }
    validates :serial, length: { maximum: 50 }

    def site
      rack.site
    end

    def ip_address
      primary_ip4 || primary_ip6
    end

    def manufacturer_id
      device_type.try(:manufacturer_id)
    end
  end
end

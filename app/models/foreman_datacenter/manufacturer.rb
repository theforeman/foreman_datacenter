module ForemanDatacenter
  class Manufacturer < ActiveRecord::Base
    has_many :device_types, :class_name => 'ForemanDatacenter::DeviceType'

    validates :name, presence: true, uniqueness: true, length: { maximum: 50 }
  end
end

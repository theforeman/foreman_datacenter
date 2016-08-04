module ForemanDatacenter
  class DeviceType < ActiveRecord::Base
    SUBDEVICE_ROLES = ['None', 'Parent', 'Child'].freeze

    belongs_to :manufacturer, :class_name => 'ForemanDatacenter::Manufacturer'
    has_many :devices, :class_name => 'ForemanDatacenter::Device'
    has_many :interface_templates, :class_name => 'ForemanDatacenter::InterfaceTemplate'

    validates :manufacturer_id, presence: true
    validates :model, presence: true, length: { maximum: 50 }
    validates :u_height, numericality: { only_integer: true }
    validates :subdevice_role, inclusion: { in: SUBDEVICE_ROLES },
              allow_blank: true
  end
end

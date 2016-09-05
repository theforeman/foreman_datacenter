module ForemanDatacenter
  class ManagementDevice < ActiveRecord::Base
    belongs_to :device, :class_name => 'ForemanDatacenter::Device'

    validates :name, presence: true, length: { maximum: 255 }
  end
end

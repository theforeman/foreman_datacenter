module ForemanDatacenter
  class ManagementDevice < ActiveRecord::Base
    belongs_to :device, :class_name => 'ForemanDatacenter::Device'

    validates :console_url, presence: true, length: { maximum: 255 }

    def to_label
      console_url
    end
  end
end

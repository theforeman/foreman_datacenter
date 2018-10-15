module ForemanDatacenter
  class DeviceBayTemplate < ActiveRecord::Base
    include ScopedSearchExtensions
    include Authorizable

    belongs_to :device_type, :class_name => 'ForemanDatacenter::DeviceType'

    validates :device_type_id, presence: true
    validates :name, presence: true, length: { maximum: 30 }

    scoped_search on: :name, complete_value: true, default_order: true

    def attrs_to_copy
      attributes.slice('name')
    end
  end
end

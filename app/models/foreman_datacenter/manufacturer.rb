module ForemanDatacenter
  class Manufacturer < ActiveRecord::Base
    include ScopedSearchExtensions
    include Authorizable

    has_many :device_types, :class_name => 'ForemanDatacenter::DeviceType'
    has_many :devices, :class_name => 'ForemanDatacenter::Device', through: :device_types

    validates :name, presence: true, uniqueness: true, length: { maximum: 50 }

    scoped_search on: :name, complete_value: true, default_order: true
    scoped_search on: :created_at, complete_value: true, default_order: true
    scoped_search on: :updated_at, complete_value: true, default_order: true

    def device_types_count
      @device_types_count ||= device_types.count
    end

    def devices_count
      @devices_count ||= self.class.where(id: id).
          joins(device_types: :devices).
          count
    end

    def self.for_host(host)
      fact = host.fact_value_by_name('manufacturer')
      if fact
        manufacturer = find_by(name: fact.value)
        if manufacturer
          manufacturer
        else
          create(name: fact.value)
        end
      end
    end
  end
end

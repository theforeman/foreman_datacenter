module ForemanDatacenter
  class Manufacturer < ActiveRecord::Base
    has_many :device_types, :class_name => 'ForemanDatacenter::DeviceType'

    validates :name, presence: true, uniqueness: true, length: { maximum: 50 }

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

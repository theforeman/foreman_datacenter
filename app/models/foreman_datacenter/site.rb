module ForemanDatacenter
  class Site < ActiveRecord::Base
    include ScopedSearchExtensions
    has_many :racks, :class_name => 'ForemanDatacenter::Rack'
    has_many :rack_groups, :class_name => 'ForemanDatacenter::RackGroup'

    validates :name, presence: true, uniqueness: true, length: { maximum: 50 }
    validates :facility, length: { maximum: 50 }, allow_blank: true
    validates_numericality_of :asn, only_integer: true, allow_nil: true
    validates :physical_address, length: { maximum: 200 }, allow_blank: true
    validates :shipping_address, length: { maximum: 200 }, allow_blank: true

    scoped_search on: :name, complete_value: true, default_order: true

    def racks_count
      @racks_count ||= racks.count
    end

    def devices_count
      @devices_count ||= self.class.where(id: id).
          joins(racks: :devices).
          count
    end
  end
end

module ForemanDatacenter
  class Site < ActiveRecord::Base
    include ScopedSearchExtensions
    include Authorizable
    
    has_many :racks, :class_name => 'ForemanDatacenter::Rack'
    has_many :rack_groups, :class_name => 'ForemanDatacenter::RackGroup'

    validates :name, presence: true, uniqueness: true, length: { maximum: 50 }
    validates :facility, length: { maximum: 50 }, allow_blank: true
    validates_numericality_of :asn, only_integer: true, allow_nil: true
    validates :physical_address, length: { maximum: 200 }, allow_blank: true
    validates :shipping_address, length: { maximum: 200 }, allow_blank: true

    scoped_search on: :name, complete_value: true, default_order: true
    scoped_search on: :facility, complete_value: true, default_order: true

    # scoped_search relation: :racks, on: :site_id, ext_method: :find_by_house
    # scoped_search relation: :racks, on: rack_count
    # named_scope :aa, lambda { |s| abort s.inspect }
    # SELECT count(*) FROM "sites" INNER JOIN "racks" ON "racks"."site_id" = "sites"."id" GROUP BY site_id;

    def racks_count
      @racks_count ||= racks.count
    end

    def devices_count
      @devices_count ||= self.class.where(id: id).
          joins(racks: :devices).
          count
    end

    def self.find_by_house#(key, operator, value)
      # conditions = sanitize_sql_for_conditions(["racks.id #{operator} ?", value_to_sql(operator, value)])
      # owners = Site.joins(:racks).where(conditions).select('site.id').map(&:id)

      # { :conditions => "site.id IN(#{owners.join(',')})" }
      # { :conditions => "SELECT count(*) FROM 'sites' INNER JOIN 'racks' ON 'racks'.'site_id' = 'sites'.'id' GROUP BY site_id UNION ALL SELECT count (*) from 'racks' WHERE 'site_id' = NULL" }
      { :conditions => "SELECT count(*) FROM 'sites' INNER JOIN 'racks' ON 'racks'.'site_id' = 'sites'.'id' GROUP BY site_id UNION ALL SELECT count (*) from 'racks' WHERE 'site_id' = NULL ORDER BY count(*)" }
    end

  end
end

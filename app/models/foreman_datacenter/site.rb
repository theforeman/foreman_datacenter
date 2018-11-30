module ForemanDatacenter
  class Site < ActiveRecord::Base
    include ScopedSearchExtensions
    include Authorizable
    
    has_many :racks, :class_name => 'ForemanDatacenter::Rack', dependent: :nullify
    has_many :rack_groups, :class_name => 'ForemanDatacenter::RackGroup', dependent: :nullify
    has_many :devices, :class_name => 'ForemanDatacenter::Device', through: :racks

    validates :name, presence: true, uniqueness: true, length: { maximum: 50 }
    validates :facility, length: { maximum: 50 }, allow_blank: true
    validates_numericality_of :asn, only_integer: true, allow_nil: true
    validates :physical_address, length: { maximum: 200 }, allow_blank: true
    validates :shipping_address, length: { maximum: 200 }, allow_blank: true

    scoped_search on: :name, complete_value: true, default_order: true
    scoped_search on: :facility, complete_value: true, default_order: true
    scoped_search on: :asn, complete_value: true, default_order: true
    scoped_search on: :physical_address, complete_value: true, default_order: true
    scoped_search on: :shipping_address, complete_value: true, default_order: true
    scoped_search on: :created_at, complete_value: true, default_order: true
    scoped_search on: :updated_at, complete_value: true, default_order: true

    def racks_count
      @racks_count ||= racks.count
    end

    def rack_groups_count
      @rack_groups_count ||= rack_groups.count
    end

    def devices_count
      @devices_count ||= self.class.where(id: id).
          joins(racks: :devices).
          count
    end

    def self.find_by_house#(key, operator, value)
      Site.includes(:racks)
        .group(['sites.id', 'racks.site_id'])
        .order('COUNT(racks.id) DESC')
        .references(:racks)
      # User.includes(:offers, :wards)
      # .group(['user.id', 'offers.id'])
      # .order('COUNT(offers.id) DESC')
      # .references(:offers)
      # conditions = sanitize_sql_for_conditions(["racks.id #{operator} ?", value_to_sql(operator, value)])
      # owners = Site.joins(:racks).where(conditions).select('site.id').map(&:id)

      # { :conditions => "site.id IN(#{owners.join(',')})" }
      # { :conditions => "SELECT count(*) FROM 'sites' INNER JOIN 'racks' ON 'racks'.'site_id' = 'sites'.'id' GROUP BY site_id UNION ALL SELECT count (*) from 'racks' WHERE 'site_id' = NULL" }
      { :conditions => "SELECT count(*) FROM 'sites' INNER JOIN 'racks' ON 'racks'.'site_id' = 'sites'.'id' GROUP BY site_id UNION ALL SELECT count (*) from 'racks' WHERE 'site_id' = NULL ORDER BY count(*)" }
    end

  end
end

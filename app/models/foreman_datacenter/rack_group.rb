module ForemanDatacenter
  class RackGroup < ActiveRecord::Base
    include ScopedSearchExtensions
    include Authorizable

    belongs_to :site, :class_name => 'ForemanDatacenter::Site'
    has_many :racks, :class_name => 'ForemanDatacenter::Rack'

    # just for test
    # has_many :comments, :class_name => 'ForemanDatacenter::Comment',
    #          dependent: :destroy, as: :commentable

    validates :site_id, presence: true
    validates :name, presence: true, length: { maximum: 50 }

    scoped_search on: :name, complete_value: true, default_order: true
    scoped_search on: :created_at, complete_value: true, default_order: true
    scoped_search on: :updated_at, complete_value: true, default_order: true

    scoped_search in: :site, on: :name, complete_value: true, rename: :site

    def racks_count
      @racks_count ||= racks.count
    end

    def devices_count
      ForemanDatacenter::Device.where(rack_id: self.racks.map(&:id)).count
    end
  end
end

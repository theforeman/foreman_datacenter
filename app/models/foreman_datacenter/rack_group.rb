module ForemanDatacenter
  class RackGroup < ActiveRecord::Base
    include ScopedSearchExtensions
    include Authorizable

    belongs_to :site, :class_name => 'ForemanDatacenter::Site'
    has_many :racks, :class_name => 'ForemanDatacenter::Rack'

    # just for test
    has_many :comments, :class_name => 'ForemanDatacenter::Comment',
             dependent: :destroy, as: :commentable


    validates :site_id, presence: true
    validates :name, presence: true, length: { maximum: 50 }

    scoped_search on: :name, complete_value: true, default_order: true
    # scoped_search relation: :site, on: :name, rename: :site
  end
end

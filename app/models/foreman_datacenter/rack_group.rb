module ForemanDatacenter
  class RackGroup < ActiveRecord::Base
    belongs_to :site, :class_name => 'ForemanDatacenter::Site'
    has_many :racks, :class_name => 'ForemanDatacenter::Rack'

    validates :site_id, presence: true
    validates :name, presence: true, length: { maximum: 50 }
  end
end

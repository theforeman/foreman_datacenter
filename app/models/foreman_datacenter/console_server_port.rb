module ForemanDatacenter
  class ConsoleServerPort < ActiveRecord::Base
    include ScopedSearchExtensions
    include Authorizable

    belongs_to :device, :class_name => 'ForemanDatacenter::Device'
    has_one :console_port, :class_name => 'ForemanDatacenter::ConsolePort'

    validates :device_id, presence: true
    validates :name, presence: true, length: { maximum: 30 }

    scoped_search on: :name, complete_value: true, default_order: true

  end
end

module ForemanDatacenter
  class DeviceRole < ActiveRecord::Base
    include ScopedSearchExtensions
    include Authorizable

    COLORS = [
        'Teal', 'Green', 'Blue', 'Purple', 'Yellow', 'Orange', 'Red',
        'Light Gray', 'Medium Gray', 'Dark Gray'
    ].freeze

    has_many :devices, :class_name => 'ForemanDatacenter::Device'

    validates :name, presence: true, uniqueness: true, length: { maximum: 50 }
    validates :color, presence: true, length: { maximum: 30 },
              inclusion: { in: COLORS, message: "Color must be one of #{COLORS.join(', ')}"}

    scoped_search on: :name, complete_value: true, default_order: true
    scoped_search on: :color, complete_value: true, default_order: true
    scoped_search on: :created_at, complete_value: true, default_order: true
    scoped_search on: :updated_at, complete_value: true, default_order: true

    def devices_count
      @devices_count ||= self.class.where(id: id).
          joins(:devices).
          count
    end

    def self.for_host
      role = find_by_name('Server')
      if role
        role
      else
        create!(name: 'Server', color: 'Green')
      end
    end
  end
end

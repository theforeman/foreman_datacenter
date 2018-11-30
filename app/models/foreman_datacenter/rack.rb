module ForemanDatacenter
  class Rack < ActiveRecord::Base
    include ScopedSearchExtensions
    include Authorizable

    belongs_to :site, :class_name => 'ForemanDatacenter::Site'
    belongs_to :rack_group, :class_name => 'ForemanDatacenter::RackGroup'
    has_many :devices, :class_name => 'ForemanDatacenter::Device'

    validates :site_id, presence: true
    validates :name, presence: true, length: { maximum: 50 }
    validates :facility_id, length: { maximum: 30 }
    validates :height, presence: true
    validates_numericality_of :height, only_integer: true, greater_than: 0

    scoped_search on: :name, complete_value: true, default_order: true
    scoped_search on: :height, validator: ScopedSearch::Validators::INTEGER
    # scoped_search relation: :site, on: :name

    def device_at(position)
      devices.where(position: position).to_a
    end

    # def positioned_devices
    #   height.downto(1).map { |position| [position, device_at(position)] }
    # end

    def positioned_devices
      devs = devices.map{ |d| [d.positions, [d]] }
      result = []
      i = 1
      loop do
        current_device = devs.select{ |d| d[0].include?(i) }
        current_device == [] ? (result << [[i],[]]; i +=1 ) : (result << merge_devices(current_device, i); i = i + current_device[0][1].last.size)
        break if i > height
      end
      device_sorting(result)
    end

    def unpositioned_devices
      devices.where(position: nil).to_a
    end

    private

    def device_sorting(devices)
      devices.reverse.map { |d| [d[0].reverse, d[1]] }
    end

    def merge_devices(devices, position)
      devs = [devices[0][0],[]]
      devices.each{|d| devs[1] << d[1][0]}
      return devs
    end
  end
end

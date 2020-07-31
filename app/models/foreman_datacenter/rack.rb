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

    scoped_search on: :name, complete_value: true
    scoped_search on: :height, validator: ScopedSearch::Validators::INTEGER
    scoped_search on: :facility_id, validator: ScopedSearch::Validators::INTEGER
    scoped_search on: :created_at, complete_value: true, default_order: true
    scoped_search on: :updated_at, complete_value: true, default_order: true

    scoped_search in: :site, on: :name, complete_value: true, rename: :site
    scoped_search in: :rack_group, on: :name, complete_value: true, rename: :rack_group

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

    def devices_count
      @devices_count ||= self.class.where(id: id).
          joins(:devices).
          count
    end

    def format_for_csv
      positioned_devices = self.positioned_devices
      unpositioned_devices = self.unpositioned_devices
      csv_string = CSV.generate do |csv|
        csv << ["positions", "left", "full", "right", "no side"]
        positioned_devices.each do |i|
          pos = i[0].map{|p| "#{p}"+"U"}.join(",")
          if i[1].size > 0
            sort = sort_for_csv(i[1])
            csv << [pos, sort[0], sort[1], sort[2], sort[3]]
          else
            csv << [pos]
          end
        end
        unless unpositioned_devices.empty?
          csv << []
          csv << ["Unpositioned", unpositioned_devices.map(&:name).join(",")]
        end

      end
      File.open("#{self.name}.csv", "w") {|f| f << csv_string}
    end

    private

    def sort_for_csv(device_array)
      left, full, right, no_side = "", "", "", []
      device_array.each do |d|
        left = d.name if d.side == "left"
        right = d.name if d.side == "right"
        full = d.name if d.side == "full"
        no_side << d.name if d.side == nil
      end
      [left, full, right, no_side.join(",")]
    end

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

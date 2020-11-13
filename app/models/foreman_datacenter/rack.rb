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
    validate :correct_position

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
      devices.where(position: nil).or(devices.where(position: "0")).to_a
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

   # Finding all empty cells for grid layout
    def empty_cells
      cells = {} # all cells of grid
      devices_cells = {} # cells with devices
      height.times.each do |i|
        cells[i+1] = ["left", "right"]
      end
      devices.each do |d|
        if d.size > 0
          if !d.position.nil? && d.position != 0
            s = (d.size == 0 || d.size == 1) ? 0 : (d.size - 1)
            places = [*d.position..d.position+s]
            places.each do |p|
              devices_cells[p] = [] unless devices_cells.key?(p)
              if (d.side == "full" || d.side.nil?)
                ["left", "right"].each {|side| devices_cells[p] << side}
              else
                devices_cells[p] << d.side
              end
            end
          end
        end
      end
      devices_cells.each do |k,v|
        v.each {|c| cells[k].delete(c)}
      end
      cells.each {|k,v| cells.except!(k) if cells[k] == []}
      return cells
    end

    def grid_template_areas
      result = {}
      (height+1).times.each do |i|
        if i == 0
          result[0] = unpositioned_devices.map{|d| "device-#{d.id}"}
        else
          dev = {}
          devices.each do |d|
            if d.size > 0
              if !d.position.nil? && d.position != 0
                css_class_name = "device-#{d.id}"
                s = (d.size == 1 || d.size == 0) ? 0 : (d.size - 1)
                if [*d.position..(d.position + s)].include?(i)
                  if d.side.nil?
                    dev["full"] = css_class_name
                  else
                    dev["#{d.side}"] = css_class_name
                  end
                  result[i] = dev
                end
              end
            end
          end
        end
      end
      (height+1).times.each do |i|
        result[i] = [] if result[i].nil?
      end
      # result[0].reject! if result[0].empty?
      return result.sort_by{|k,v| k}.to_h.to_json
    end

    def child_devices
      devices.joins(:device_type).where("device_types.subdevice_role = ?", "Child")
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

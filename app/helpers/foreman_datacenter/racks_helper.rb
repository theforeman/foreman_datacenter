module ForemanDatacenter
  module RacksHelper
    def rack_groups_for_select(rack)
      collection = rack.site ? rack.site.rack_groups : []
      options_from_collection_for_select(collection, 'id', 'name', rack.rack_group_id)
    end

    def grid_u_desc(rack)
      i = rack.height + 1
      limit = 0
      result = ""

      while limit <= i do
        if i == 0 && !rack.unpositioned_devices.empty?
          concat content_tag(:div, "Unpositioned Devices")
        else
          if i != 0
            if rack.child_devices.any? { |d| d.position == i }
              concat content_tag :div, &-> do
                concat "#{i}U"
                rack.child_devices.each do |d|
                  if d.position == i
                    concat content_tag :strong, &-> do
                      concat link_to("Child", device_path(d))
                    end
                  end
                end
              end
            else
              concat content_tag(:div, "#{i}U")
            end
          end
        end
        i -= 1
      end
    end

    def grid_empty_style(cell, id)
      case cell[1]
      when ["right"]
        column = "grid-area: rack-#{id}-row-#{cell[0]}-right-empty"
      when ["left"]
        column = "grid-area: rack-#{id}-row-#{cell[0]}-left-empty"
      when ["left", "right"] || ["right", "left"]
        column = "grid-area: rack-#{id}-row-#{cell[0]}-full-empty"
      end
			return column
    end

    def margin_style(height)
      result = "top: "
      case height
      when 1
        result += "7%"
      when 2
        result += "30%"
      when 3
        result += "35%"
      when 4
        result += "40%"
      else
        result += "45%"
      end
    end

    def grid_rack_style(device)
      css_class_name = device.name.gsub(/[.@#\s]/, "_")
      return "grid-area: #{css_class_name}"
    end

    def grid_rack_height(height)
			return (height + 1)
    end

    def grid_template(grid, id, order)
      result = []
      gr = JSON.parse(grid)
      gr = gr.to_a.reverse.to_h if order == "desc"

      gr.each do |k,v|
        row = "rack-#{id}-u#{k}"
        if v.instance_of? Array
          if k == "0"
            row += " rack-#{id}-unpos-devs rack-#{id}-unpos-devs"
          else
            row += " rack-#{id}-row-#{k}-full-empty rack-#{id}-row-#{k}-full-empty"
          end
        else
          if v.size > 1
            row += " #{v['left']} #{v['right']}"
          else
            row += " #{v['left']} rack-#{id}-row-#{k}-right-empty" if v.key?("left")
            row += " rack-#{id}-row-#{k}-left-empty #{v['right']}" if v.key?("right")
            row += " #{v['full']} #{v['full']}" if v.key?("full")
          end
        end
        result << row
      end
      final = result.join("' '").prepend("'") + "'"
      return "grid-template-areas: #{final}; grid-template-columns: 22% 39% 39%"
    end

  end
end

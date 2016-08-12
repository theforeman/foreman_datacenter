module ForemanDatacenter
  module DeviceInterfaceConnectionsHelper
    def racks_for_connection_form(connection)
      site = connection.first_device.rack.site
      collection = ForemanDatacenter::Rack.select(:id, :name).where(site: site)
      select_tag :rack_id,
                 options_from_collection_for_select(collection, 'id', 'name'),
                 { :include_blank => 'Choose a rack', :class => 'form-control',
                   :'data-url' => devices_device_interface_connections_path,
                   :onchange => 'connectionsNewRackSelected(this)' }

    end

    def devices_for_connection_form(devices)
      select_tag :device_id,
                 options_from_collection_for_select(devices, :id, :name),
                 { :include_blank => 'Choose a device', :class => 'form-control',
                   :'data-url' => interfaces_device_interface_connections_path,
                   :onchange => 'connectionsNewDeviceSelected(this)' }
    end

    def interfaces_for_connection_form(f, interfaces)
      selectable_f f, :interface_b,
                   options_from_collection_for_select(interfaces, :id, :name),
                   { include_blank: 'Choose an interface' },
                   { required: true, label: 'Interface', help_inline: 'And then specify an interface' }

    end
  end
end

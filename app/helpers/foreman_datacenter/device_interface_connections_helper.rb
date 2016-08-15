module ForemanDatacenter
  module DeviceInterfaceConnectionsHelper
    def interfaces_for_connection_form(f, interfaces)
      selectable_f f, :interface_b,
                   options_from_collection_for_select(interfaces, :id, :name),
                   { include_blank: 'Choose an interface' },
                   { required: true, label: 'Interface', help_inline: 'And then specify an interface' }
    end
  end
end

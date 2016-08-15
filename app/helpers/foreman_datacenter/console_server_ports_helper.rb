module ForemanDatacenter
  module ConsoleServerPortsHelper
    def console_server_ports_list_for_device(f, device = nil)
      collection = device ? device.console_ports.select(:id, :name) : []
      selectable_f f, :id,
                   options_from_collection_for_select(collection, :id, :name),
                   { include_blank: 'Choose a port' },
                   { required: true, label: 'Port', help_inline: 'And then specify a port' }

    end
  end
end

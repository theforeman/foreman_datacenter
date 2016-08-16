module ForemanDatacenter
  module PowerOutletsHelper
    def power_outlets_list_for_device(f, device = nil)
      collection = device ? device.free_power_outlets.select(:id, :name) : []
      selectable_f f, :id,
                   options_from_collection_for_select(collection, :id, :name),
                   { include_blank: 'Choose a power outlet' },
                   { required: true, label: 'Port', help_inline: 'And then specify a power outlet' }
    end
  end
end

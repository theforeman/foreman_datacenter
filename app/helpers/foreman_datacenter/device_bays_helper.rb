module ForemanDatacenter
  module DeviceBaysHelper
    def child_devices_for_device_bay_form(f, device_bay)
      devices = device_bay.available_child_devices.select(:id, :name)
      selectable_f f, :installed_device_id,
                   options_from_collection_for_select(devices, 'id', 'name'),
                   {include_blank: 'Choose a child device'},
                   help_inline: 'Child devices must first be created within the rack occupied by the parent device. Then they can be assigned to a bay.',
                   required: true, label: 'Child Device'
    end
  end
end

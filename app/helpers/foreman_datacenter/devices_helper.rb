module ForemanDatacenter
  module DevicesHelper
    def device_roles_for_select(selected_id = nil)
      options_from_collection_for_select(DeviceRole.all, 'id', 'name', selected_id)
    end

    def device_manufacturers_for_select(selected_id = nil)
      options_from_collection_for_select(Manufacturer.all, 'id', 'name', selected_id)
    end

    def device_types_for_device_form(f, manufacturer_id, device_type_id = nil)
      if manufacturer_id
        collection = DeviceType.select(:id, :model).
          where(manufacturer_id: manufacturer_id).
          all
      else
        collection = []
      end
      selectable_f f, :device_type_id,
                   options_from_collection_for_select(collection, 'id', 'model', device_type_id),
                   { include_blank: 'Choose a device type' },
                   { required: true, label: 'Device Type' }
    end

    def racks_for_device_form(f, site_id, rack_id = nil)
      if site_id
        collection = Rack.where(site_id: site_id).select(:id, :name).all
      else
        collection = []
      end
      selectable_f f, :rack_id,
                   options_from_collection_for_select(collection, 'id', 'name', rack_id),
                   { include_blank: 'Choose a rack' },
                   { required: true, label: 'Rack' }
    end

    def sites_for_device_form(site_id)
      collection = Site.select(:id, :name).all
      select_tag :site_id,
                 options_from_collection_for_select(collection, 'id', 'name', site_id),
                 { :include_blank => 'Choose a site',
                   :onchange => 'devicesNewSiteSelected(this)',
                   :'data-url' => racks_devices_path,
                   :class => 'form-control' }
    end

    def platforms_for_device_form(f, platform_id)
      collection = Platform.select(:id, :name).all
      selectable_f f, :platform_id,
                   options_from_collection_for_select(collection, 'id', 'name', platform_id),
                   { include_blank: 'Choose a platform', label: 'Platform' }
    end
  end
end

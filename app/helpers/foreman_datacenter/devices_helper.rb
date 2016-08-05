module ForemanDatacenter
  module DevicesHelper
    def device_roles_for_select(selected_id = nil)
      options_from_collection_for_select(DeviceRole.all, 'id', 'name', selected_id)
    end

    def device_manufacturers_for_select(selected_id = nil)
      options_from_collection_for_select(Manufacturer.all, 'id', 'name', selected_id)
    end

    def device_types_for_select(manufacturer_id, selected_id)
      if manufacturer_id
        collection = DeviceType.where(manufacturer_id: manufacturer_id).all
      else
        collection = []
      end
      options_from_collection_for_select(collection, 'id', 'model', selected_id)
    end
  end
end

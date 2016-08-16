module ForemanDatacenter
  module DeviceTypesHelper
    def device_type_subdevice_roles
      DeviceType::SUBDEVICE_ROLES.zip(DeviceType::SUBDEVICE_ROLES)
    end
  end
end

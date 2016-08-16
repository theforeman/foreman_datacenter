module ForemanDatacenter
  module DeviceRolesHelper
    def device_role_colors_for_select
      DeviceRole::COLORS.zip(DeviceRole::COLORS)
    end
  end
end

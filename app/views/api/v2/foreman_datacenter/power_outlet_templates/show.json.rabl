object @power_outlet_template

extends "api/v2/foreman_datacenter/power_outlet_templates/main"

child :device_type do
  extends "api/v2/foreman_datacenter/device_types/base"
end

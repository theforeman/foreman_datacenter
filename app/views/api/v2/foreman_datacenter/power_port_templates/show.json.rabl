object @power_port_template

extends "api/v2/foreman_datacenter/power_port_templates/main"

child :device_type do
  extends "api/v2/foreman_datacenter/device_types/base"
end

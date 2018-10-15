object @device_type

extends "api/v2/foreman_datacenter/device_types/show"

child :console_port_templates do
  extends "api/v2/foreman_datacenter/console_port_templates/base"
end

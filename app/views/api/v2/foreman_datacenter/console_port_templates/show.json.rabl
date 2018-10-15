object @console_port_template

extends "api/v2/foreman_datacenter/console_port_templates/main"

child :device_type do
  extends "api/v2/foreman_datacenter/device_types/base"
end

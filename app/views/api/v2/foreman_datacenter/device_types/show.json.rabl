object @device_type

extends "api/v2/foreman_datacenter/device_types/main"

child :manufacturer do
  extends "api/v2/foreman_datacenter/manufacturers/base"
end

child :console_port_templates do
  extends "api/v2/foreman_datacenter/console_port_templates/base"
end

child :console_server_port_templates do
  extends "api/v2/foreman_datacenter/console_server_port_templates/base"
end

child :device_bay_templates do
  extends "api/v2/foreman_datacenter/device_bay_templates/base"
end

child :interface_templates do
  extends "api/v2/foreman_datacenter/interface_templates/base"
end

child :power_port_templates do
  extends "api/v2/foreman_datacenter/power_port_templates/base"
end

child :power_outlet_templates do
  extends "api/v2/foreman_datacenter/power_outlet_templates/base"
end

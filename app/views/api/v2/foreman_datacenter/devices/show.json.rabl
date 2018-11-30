object @device

extends "api/v2/foreman_datacenter/devices/main"

child :device_type do
  extends "api/v2/foreman_datacenter/device_types/base"
end

child :device_role do
  extends "api/v2/foreman_datacenter/device_roles/base"
end

child :platform do
  extends "api/v2/foreman_datacenter/platforms/base"
end

child :manufacturer do
  extends "api/v2/foreman_datacenter/manufacturers/base"
end

child :rack do
  extends "api/v2/foreman_datacenter/racks/base"
end

child :site do
  extends "api/v2/foreman_datacenter/sites/base"
end

child :host do
  extends "api/v2/hosts/base"
end

child :console_ports do
  extends "api/v2/foreman_datacenter/console_ports/base"
end

child :console_server_ports do
  extends "api/v2/foreman_datacenter/console_server_ports/base"
end

child :device_bays do
  extends "api/v2/foreman_datacenter/device_bays/base"
end

child :device_interfaces do
  extends "api/v2/foreman_datacenter/device_interfaces/base"
end

child :device_modules do
  extends "api/v2/foreman_datacenter/device_modules/base"
end

child :power_ports do
  extends "api/v2/foreman_datacenter/power_ports/base"
end

child :power_outlets do
  extends "api/v2/foreman_datacenter/power_outlets/base"
end

child :interfaces do
  extends "api/v2/foreman_datacenter/interfaces/base"
end

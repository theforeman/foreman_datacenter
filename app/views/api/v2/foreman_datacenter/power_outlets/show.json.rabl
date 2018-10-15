object @power_outlet

extends "api/v2/foreman_datacenter/power_outlets/main"

child :device do
  extends "api/v2/foreman_datacenter/devices/base"
end

child :power_port do
  extends "api/v2/foreman_datacenter/power_port/base"
end

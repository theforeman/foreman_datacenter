object @management_device

extends "api/v2/foreman_datacenter/management_devices/main"

child :device do
  extends "api/v2/foreman_datacenter/devices/base"
end

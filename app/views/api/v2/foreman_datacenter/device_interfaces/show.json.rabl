object @device_interface

extends "api/v2/foreman_datacenter/device_interfaces/main"

child :device do
  extends "api/v2/foreman_datacenter/devices/base"
end

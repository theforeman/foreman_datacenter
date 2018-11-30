object @device_bay

extends "api/v2/foreman_datacenter/device_bays/main"

child :device do
  extends "api/v2/foreman_datacenter/devices/base"
end

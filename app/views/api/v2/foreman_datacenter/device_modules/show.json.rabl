object @device_module

extends "api/v2/foreman_datacenter/device_modules/main"

child :device do
  extends "api/v2/foreman_datacenter/devices/base"
end

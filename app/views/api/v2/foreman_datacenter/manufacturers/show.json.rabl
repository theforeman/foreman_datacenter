object @manufacturer

extends "api/v2/foreman_datacenter/manufacturers/main"

child :device_types do
  extends "api/v2/foreman_datacenter/device_types/base"
end

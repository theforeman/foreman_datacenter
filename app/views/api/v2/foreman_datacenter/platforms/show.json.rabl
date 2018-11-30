object @platform

extends "api/v2/foreman_datacenter/platforms/main"

child :devices do
  extends "api/v2/foreman_datacenter/devices/base"
end

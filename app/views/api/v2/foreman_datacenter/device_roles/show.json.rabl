object @device_role

extends "api/v2/foreman_datacenter/device_roles/main"

child :devices do
  extends "api/v2/foreman_datacenter/devices/base"
end

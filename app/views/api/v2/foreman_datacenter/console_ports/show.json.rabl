object @console_port

extends "api/v2/foreman_datacenter/console_ports/main"

child :device do
  extends "api/v2/foreman_datacenter/devices/base"
end

child :console_server_port do
  extends "api/v2/foreman_datacenter/console_server_ports/base"
end

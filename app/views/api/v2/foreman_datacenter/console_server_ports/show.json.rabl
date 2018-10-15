object @console_server_port

extends "api/v2/foreman_datacenter/console_server_ports/main"

child :device do
  extends "api/v2/foreman_datacenter/devices/base"
end

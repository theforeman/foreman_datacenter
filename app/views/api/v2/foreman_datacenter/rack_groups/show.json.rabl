object @rack_group

extends "api/v2/foreman_datacenter/rack_groups/main"

child :site do
  extends "api/v2/foreman_datacenter/sites/base"
end

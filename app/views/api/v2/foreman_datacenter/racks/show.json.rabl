object @rack

extends "api/v2/foreman_datacenter/racks/main"

child :site do
  extends "api/v2/foreman_datacenter/sites/base"
end

child :rack_group do
  extends "api/v2/foreman_datacenter/rack_groups/base"
end

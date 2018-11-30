object @site

extends "api/v2/foreman_datacenter/sites/main"

child :racks do
  extends "api/v2/foreman_datacenter/racks/base"
end

child :rack_groups do
  extends "api/v2/foreman_datacenter/rack_groups/base"
end

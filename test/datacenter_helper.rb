class ActiveSupport::TestCase
  set_fixture_class :sites => ForemanDatacenter::Site
  set_fixture_class :racks => ForemanDatacenter::Rack
  set_fixture_class :rack_groups => ForemanDatacenter::RackGroup
  set_fixture_class :platforms => ForemanDatacenter::Platform
  set_fixture_class :manufacturers => ForemanDatacenter::Manufacturer
  set_fixture_class :device_types => ForemanDatacenter::DeviceType
  set_fixture_class :device_roles => ForemanDatacenter::DeviceRole
  set_fixture_class :devices => ForemanDatacenter::Device
  fixtures :all
end

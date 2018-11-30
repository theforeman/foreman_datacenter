FactoryBot.define do
  factory :device_type, :class => ForemanDatacenter::DeviceType do
    sequence(:model) {|n| "dt-#{n}"}
    sequence(:manufacturer_id) { 1 }
    # sequence(:u_height) { 5 }
    # sequence(:is_full_depth) { true }
    # sequence(:is_console_server) { true }
    # sequence(:is_pdu) { true }
    # sequence(:is_network_device) { true }
    # sequence(:created_at) { "2018-09-20 13:22:33.400027" }
    # sequence(:updated_at) { "2018-09-20 13:22:33.400027" }
  end
end

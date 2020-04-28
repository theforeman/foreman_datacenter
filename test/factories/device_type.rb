FactoryBot.define do
  factory :device_type, :class => ForemanDatacenter::DeviceType do
    sequence(:model) {|n| "dt-#{n}"}
    sequence(:manufacturer_id) { 1 }

    trait :full_depth do
      is_full_depth { true }
    end

    trait :console_server do
      is_console_server { true }
    end

    trait :pdu do
      is_pdu { true }
    end

    trait :network_device do
      is_network_device { true }
    end

    trait :parent do
      subdevice_role "Parent"
    end

    trait :child do
      subdevice_role "Child"
      u_height 0
    end

    trait :none do
      subdevice_role "None"
    end

    # sequence(:u_height) { 5 }
    # sequence(:is_full_depth) { true }
    # sequence(:is_console_server) { true }
    # sequence(:is_pdu) { true }
    # sequence(:is_network_device) { true }
    # sequence(:created_at) { "2018-09-20 13:22:33.400027" }
    # sequence(:updated_at) { "2018-09-20 13:22:33.400027" }
  end
end

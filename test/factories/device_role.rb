FactoryBot.define do
  factory :device_role, :class => ForemanDatacenter::DeviceRole do
    sequence(:name) {|n| "dev_role_#{n}"}
    color { "Red" }
  end
end

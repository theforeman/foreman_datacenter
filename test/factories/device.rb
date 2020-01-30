FactoryBot.define do
  factory :device, :class => ForemanDatacenter::Device do
    sequence(:name) {|n| "device-#{n}"}
  end
end

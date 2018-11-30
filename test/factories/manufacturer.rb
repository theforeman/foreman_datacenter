FactoryBot.define do
  factory :manufacturer, :class => ForemanDatacenter::Manufacturer do
    sequence(:name) {|n| "manufacturer-#{n}"}
  end
end

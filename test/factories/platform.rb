FactoryBot.define do
  factory :platform, :class => ForemanDatacenter::Platform do
    sequence(:name) {|n| "platform-#{n}"}
  end
end

FactoryBot.define do
  factory :site, :class => ForemanDatacenter::Site do
    sequence(:name) {|n| "site-#{n}"}
  end
end

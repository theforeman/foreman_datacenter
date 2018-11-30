FactoryBot.define do
  factory :rack, :class => ForemanDatacenter::Rack do
    sequence(:name) {|n| "rack_#{n}"}
    sequence(:height) { 5 }
    sequence(:site_id) { 1 }
    sequence(:rack_group_id) { 1 }
  end
end

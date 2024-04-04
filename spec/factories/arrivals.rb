FactoryBot.define do
  factory :arrival do
    association :station
    association :walk
  end
end

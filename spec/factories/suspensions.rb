# frozen_string_literal: true

FactoryBot.define do
  factory :suspension do
    association :walk
    started_at { Time.current }

    trait :ended do
      ended_at { started_at + 30.minutes }
    end
  end
end

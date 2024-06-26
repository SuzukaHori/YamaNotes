# frozen_string_literal: true

FactoryBot.define do
  factory :arrival do
    association :station
    association :walk
    arrived_at { Time.current }
  end
end

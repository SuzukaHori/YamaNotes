# frozen_string_literal: true

FactoryBot.define do
  factory :walk do
    association :user

    trait :with_arrivals do
      transient do
        arrivals_count { 1 }
      end

      after(:build) do |walk, evaluator|
        evaluator.arrivals_count.times do
          if walk.arrivals.empty?
            FactoryBot.create(:arrival, walk:, station_id: 1)
          else
            next_station = walk.current_station.next(clockwise: walk.clockwise)
            FactoryBot.create(:arrival, walk:, station: next_station)
          end
        end
      end
    end
  end
end

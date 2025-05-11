# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:uid) { |n| 10_000_000_000 + n }
    provider { 'google_oauth2' }

    trait :with_walk do
      after(:create) do |user|
        FactoryBot.create(:walk, :with_arrivals, user: user)
      end
    end
  end
end

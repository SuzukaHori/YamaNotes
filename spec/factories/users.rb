FactoryBot.define do
  factory :user do
    sequence(:uid) { |n| 10_000_000_000 + n }
    provider { 'google_oauth2' }
  end
end

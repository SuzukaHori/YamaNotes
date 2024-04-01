FactoryBot.define do
  factory :user do
    sequence(:uid) { |n| 10000000000 + n }
    provider { "google_oauth2" }
  end
end

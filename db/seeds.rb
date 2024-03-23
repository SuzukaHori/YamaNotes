# frozen_string_literal: true

Station.create!(
  name: "渋谷",
  longitude: 11111,
  latitude: 222222,
  clockwise_distance_to_next: 2.4,
  counterclockwise_distance_to_next: 3.3
)

Station.create!(
  name: "新宿",
  longitude: 11111,
  latitude: 222222,
  clockwise_distance_to_next: 2.4,
  counterclockwise_distance_to_next: 3.3
)

Station.create!(
  name: "原宿",
  longitude: 11111,
  latitude: 222222,
  clockwise_distance_to_next: 2.4,
  counterclockwise_distance_to_next: 3.3
)

user = User.create!(
  uid: 1111111111,
  provider: "google_oauth2"
)

walk = user.build_walk(
  clockwise: true
)

walk.save!

walk.arrivals.create!(
  station_id: 1
)

walk.arrivals.create!(
  station_id: 3
)

# frozen_string_literal: true

Station.create!(
  name: '品川',
  longitude: 11_111,
  latitude: 222_222,
  clockwise_distance_to_next: 2.4,
  counterclockwise_distance_to_next: 3.3
)

Station.create!(
  name: '大崎',
  longitude: 11_111,
  latitude: 222_222,
  clockwise_distance_to_next: 2.4,
  counterclockwise_distance_to_next: 3.3
)

Station.create!(
  name: '五反田',
  longitude: 11_111,
  latitude: 222_222,
  clockwise_distance_to_next: 2.4,
  counterclockwise_distance_to_next: 3.3
)

Station.create!(
  name: '目黒',
  longitude: 11_111,
  latitude: 222_222,
  clockwise_distance_to_next: 2.4,
  counterclockwise_distance_to_next: 3.3
)

user = User.create!(
  uid: 1_111_111_111,
  provider: 'google_oauth2'
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

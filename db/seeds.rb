# frozen_string_literal: true

stations = [
  { name: '品川', latitude: 35.628471, longitude: 139.73876, clockwise_distance_to_next: 2.0 },
  { name: '大崎', latitude: 35.6197, longitude: 139.728553, clockwise_distance_to_next: 0.9 },
  { name: '五反田', latitude: 35.625974, longitude: 139.723188, clockwise_distance_to_next: 1.2 },
  { name: '目黒', latitude: 35.633998, longitude: 139.715828, clockwise_distance_to_next: 1.5 },
  { name: '恵比寿', latitude: 35.64669, longitude: 139.710106, clockwise_distance_to_next: 1.6 },
  { name: '渋谷', latitude: 35.658034, longitude: 139.701636, clockwise_distance_to_next: 1.2 },
  { name: '原宿', latitude: 35.670168, longitude: 139.702687, clockwise_distance_to_next: 1.5 },
  { name: '代々木', latitude: 35.683061, longitude: 139.702042, clockwise_distance_to_next: 0.7 },
  { name: '新宿', latitude: 35.689596, longitude: 139.700429, clockwise_distance_to_next: 1.3 },
  { name: '新大久保', latitude: 35.700429, longitude: 139.700218, clockwise_distance_to_next: 1.4 },
  { name: '高田馬場', latitude: 35.712285, longitude: 139.703782, clockwise_distance_to_next: 0.9 },
  { name: '目白', latitude: 35.721204, longitude: 139.706587, clockwise_distance_to_next: 1.2 },
  { name: '池袋', latitude: 35.729503, longitude: 139.7109, clockwise_distance_to_next: 1.8 },
  { name: '大塚', latitude: 35.731412, longitude: 139.729025, clockwise_distance_to_next: 0.7 },
  { name: '巣鴨', latitude: 35.733445, longitude: 139.739345, clockwise_distance_to_next: 1.1 },
  { name: '駒込', latitude: 35.736489, longitude: 139.746875, clockwise_distance_to_next: 1.6 },
  { name: '田端', latitude: 35.738062, longitude: 139.76086, clockwise_distance_to_next: 0.8 },
  { name: '西日暮里', latitude: 35.732135, longitude: 139.766787, clockwise_distance_to_next: 0.5 },
  { name: '日暮里', latitude: 35.727772, longitude: 139.770987, clockwise_distance_to_next: 1.1 },
  { name: '鶯谷', latitude: 35.721204, longitude: 139.778015, clockwise_distance_to_next: 1.1 },
  { name: '上野', latitude: 35.713768, longitude: 139.777254, clockwise_distance_to_next: 0.6 },
  { name: '御徒町', latitude: 35.707438, longitude: 139.774632, clockwise_distance_to_next: 1.0 },
  { name: '秋葉原', latitude: 35.698683, longitude: 139.774219, clockwise_distance_to_next: 0.7 },
  { name: '神田', latitude: 35.69169, longitude: 139.770883, clockwise_distance_to_next: 1.3 },
  { name: '東京', latitude: 35.681391, longitude: 139.766103, clockwise_distance_to_next: 0.8 },
  { name: '有楽町', latitude: 35.675069, longitude: 139.763328, clockwise_distance_to_next: 1.1 },
  { name: '新橋', latitude: 35.665498, longitude: 139.75964, clockwise_distance_to_next: 1.2 },
  { name: '浜松町', latitude: 35.655646, longitude: 139.757272, clockwise_distance_to_next: 1.5 },
  { name: '田町', latitude: 35.645736, longitude: 139.747575, clockwise_distance_to_next: 1.3 },
  { name: '高輪ゲートウェイ', latitude: 35.63569, longitude: 139.74044, clockwise_distance_to_next: 0.9 }
]

if Station.all.empty?
  stations_instances = stations.map do |station|
    Station.new(
      name: station[:name],
      latitude: station[:latitude],
      longitude: station[:longitude],
      clockwise_distance_to_next: station[:clockwise_distance_to_next]
    )
  end

  stations_instances.each_with_index do |station, i|
    next_id = i > 28 ? i - 28 : i + 2
    station.clockwise_next_station_id = next_id
  end

  stations_instances.each { |station| station.save!(validate: false) }
end

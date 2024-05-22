# frozen_string_literal: true

stations = [
  { "id": 1, "name": '品川', "latitude": 35.628471, "longitude": 139.73876, "clockwise_distance_to_next": 2.0, "clockwise_next_station_id": 2 },
  { "id": 2, "name": '大崎', "latitude": 35.6197, "longitude": 139.728553, "clockwise_distance_to_next": 0.9, "clockwise_next_station_id": 3 },
  { "id": 3, "name": '五反田', "latitude": 35.625974, "longitude": 139.723188, "clockwise_distance_to_next": 1.2, "clockwise_next_station_id": 4 },
  { "id": 4, "name": '目黒', "latitude": 35.633998, "longitude": 139.715828, "clockwise_distance_to_next": 1.5, "clockwise_next_station_id": 5 },
  { "id": 5, "name": '恵比寿', "latitude": 35.64669, "longitude": 139.710106, "clockwise_distance_to_next": 1.6, "clockwise_next_station_id": 6 },
  { "id": 6, "name": '渋谷', "latitude": 35.658034, "longitude": 139.701636, "clockwise_distance_to_next": 1.4, "clockwise_next_station_id": 7 },
  { "id": 7, "name": '原宿', "latitude": 35.670168, "longitude": 139.702687, "clockwise_distance_to_next": 1.6, "clockwise_next_station_id": 8 },
  { "id": 8, "name": '代々木', "latitude": 35.683061, "longitude": 139.702042, "clockwise_distance_to_next": 0.8, "clockwise_next_station_id": 9 },
  { "id": 9, "name": '新宿', "latitude": 35.689596, "longitude": 139.700429, "clockwise_distance_to_next": 1.4, "clockwise_next_station_id": 10 },
  { "id": 10, "name": '新大久保', "latitude": 35.700429, "longitude": 139.700218, "clockwise_distance_to_next": 1.5, "clockwise_next_station_id": 11 },
  { "id": 11, "name": '高田馬場', "latitude": 35.712285, "longitude": 139.703782, "clockwise_distance_to_next": 1.1, "clockwise_next_station_id": 12 },
  { "id": 12, "name": '目白', "latitude": 35.721204, "longitude": 139.706587, "clockwise_distance_to_next": 1.3, "clockwise_next_station_id": 13 },
  { "id": 13, "name": '池袋', "latitude": 35.729503, "longitude": 139.7109, "clockwise_distance_to_next": 1.8, "clockwise_next_station_id": 14 },
  { "id": 14, "name": '大塚', "latitude": 35.731412, "longitude": 139.729025, "clockwise_distance_to_next": 1.0, "clockwise_next_station_id": 15 },
  { "id": 15, "name": '巣鴨', "latitude": 35.733445, "longitude": 139.739345, "clockwise_distance_to_next": 0.9, "clockwise_next_station_id": 16 },
  { "id": 16, "name": '駒込', "latitude": 35.736489, "longitude": 139.746875, "clockwise_distance_to_next": 1.6, "clockwise_next_station_id": 17 },
  { "id": 17, "name": '田端', "latitude": 35.738062, "longitude": 139.76086, "clockwise_distance_to_next": 1.0, "clockwise_next_station_id": 18 },
  { "id": 18, "name": '西日暮里', "latitude": 35.732135, "longitude": 139.766787, "clockwise_distance_to_next": 0.7, "clockwise_next_station_id": 19 },
  { "id": 19, "name": '日暮里', "latitude": 35.727772, "longitude": 139.770987, "clockwise_distance_to_next": 1.4, "clockwise_next_station_id": 20 },
  { "id": 20, "name": '鶯谷', "latitude": 35.721204, "longitude": 139.778015, "clockwise_distance_to_next": 0.9, "clockwise_next_station_id": 21 },
  { "id": 21, "name": '上野', "latitude": 35.713768, "longitude": 139.777254, "clockwise_distance_to_next": 0.9, "clockwise_next_station_id": 22 },
  { "id": 22, "name": '御徒町', "latitude": 35.707438, "longitude": 139.774632, "clockwise_distance_to_next": 1.0, "clockwise_next_station_id": 23 },
  { "id": 23, "name": '秋葉原', "latitude": 35.698683, "longitude": 139.774219, "clockwise_distance_to_next": 0.8, "clockwise_next_station_id": 24 },
  { "id": 24, "name": '神田', "latitude": 35.69169, "longitude": 139.770883, "clockwise_distance_to_next": 1.6, "clockwise_next_station_id": 25 },
  { "id": 25, "name": '東京', "latitude": 35.681391, "longitude": 139.766103, "clockwise_distance_to_next": 1.0, "clockwise_next_station_id": 26 },
  { "id": 26, "name": '有楽町', "latitude": 35.675069, "longitude": 139.763328, "clockwise_distance_to_next": 1.0, "clockwise_next_station_id": 27 },
  { "id": 27, "name": '新橋', "latitude": 35.665498, "longitude": 139.75964, "clockwise_distance_to_next": 1.6, "clockwise_next_station_id": 28 },
  { "id": 28, "name": '浜松町', "latitude": 35.655646, "longitude": 139.757272, "clockwise_distance_to_next": 1.6, "clockwise_next_station_id": 29 },
  { "id": 29, "name": '田町', "latitude": 35.645736, "longitude": 139.747575, "clockwise_distance_to_next": 1.7, "clockwise_next_station_id": 30 },
  { "id": 30, "name": '高輪ゲートウェイ', "latitude": 35.63569, "longitude": 139.74044, "clockwise_distance_to_next": 1.0, "clockwise_next_station_id": 1 }
]

if Station.exists?
  puts '駅のデータがすでに存在するため、作成しませんでした'
else
  stations_instances = stations.map { |station| Station.new(station) }
  Station.transaction do
    stations_instances.each { |station| station.save!(validate: false) }
    puts '駅のデータを作成しました'
  end
end

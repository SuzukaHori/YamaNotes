module WalksHelper
  def current_walk
    current_user.walk
  end

  def remaining_stations_number
    Station.count - current_walk.arrived.length
  end

  def remaining_distance
    (Station.total_distance - current_walk.arrived_stations.sum(&:clockwise_distance_to_next)).round(2)
  end

  def elapsed_time
    elapsed_seconds = Time.current - current_walk.created_at
    hours = (elapsed_seconds / 3600).to_i
    minutes = ((elapsed_seconds % 3600) / 60).to_i
    "#{hours}時間#{minutes}分"
  end
end

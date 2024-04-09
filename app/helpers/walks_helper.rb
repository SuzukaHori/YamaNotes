module WalksHelper
  def current_walk
    current_user.walk
  end

  def remaining_distance
    (Station.total_distance - current_walk.total_distance_walked).round(2)
  end

  def elapsed_time
    elapsed_seconds = Time.current - current_walk.created_at
    hours = (elapsed_seconds / 3600).to_i
    minutes = ((elapsed_seconds % 3600) / 60).to_i
    "#{hours}時間#{minutes}分"
  end

  def walked_stations_number
    current_walk.arrivals_without_departure.length
  end
end

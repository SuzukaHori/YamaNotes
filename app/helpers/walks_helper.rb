module WalksHelper
  def current_walk
    current_user.walk
  end

  def total_distance
    current_walk.total_distance_finished.round(2)
  end

  def remaining_distance
    (Station.total_distance - current_walk.total_distance_finished).round(2)
  end

  def elapsed_time
    elapsed_seconds = Time.current - current_walk.created_at
    hours = (elapsed_seconds / 3600).to_i
    minutes = ((elapsed_seconds % 3600) / 60).to_i
    "#{hours}時間#{minutes}分"
  end

  def number_of_walked_stations
    arrivals_without_departure = current_walk.arrivals.slice(1..-1)
    arrivals_without_departure.length
  end

  def number_of_remaining_stations
    Station.count - number_of_walked_stations
  end
end

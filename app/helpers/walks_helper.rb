module WalksHelper
  def current_walk
    current_user.walk
  end

  def total_distance(arrivals)
    arrivals_distance(arrivals) - arrivals.last.station.clockwise_distance_to_next
  end

  def remaining_distance(arrivals)
    (Station.total_distance - total_distance(arrivals)).round(2)
  end

  def elapsed_time(walk)
    elapsed_seconds = Time.current - walk.created_at
    hours = (elapsed_seconds / 3600).to_i
    minutes = ((elapsed_seconds % 3600) / 60).to_i
    "#{hours}時間#{minutes}分"
  end

  def number_of_walked(arrivals)
    arrivals_without_departure = arrivals.slice(1..-1)
    arrivals_without_departure.length
  end

  def number_of_remaining(arrivals)
    Station.count - number_of_walked(arrivals)
  end

  def time_to_reach_goal(walk)
    return unless walk.finished?

    Time.at(walk.arrival_of_goal.arrived_at - walk.arrival_of_departure.arrived_at).utc.strftime('%k時間%M分')
  end

  private

  def arrivals_distance(arrivals)
    arrivals.map(&:station).sum(&:clockwise_distance_to_next)
  end
end

module ArrivalsHelper
  def current_walk
    current_user&.walk
  end

  def total_distance(arrivals)
    (arrivals_distance(arrivals) - arrivals.last.station.clockwise_distance_to_next).round(2)
  end

  def remaining_distance(arrivals)
    (Station.total_distance - total_distance(arrivals)).round(2)
  end

  def number_of_walked(arrivals)
    arrivals_without_departure = arrivals.slice(1..-1)
    arrivals_without_departure.length
  end

  def number_of_remaining(arrivals)
    Station.count - number_of_walked(arrivals)
  end

  def deletable?(arrival, walk)
    current_user == walk.user && arrival == walk.arrivals.last && arrival != walk.arrival_of_departure
  end

  private

  def arrivals_distance(arrivals)
    arrivals.map(&:station).sum(&:clockwise_distance_to_next)
  end
end

# frozen_string_literal: true

module ArrivalsHelper
  def arrived_distance(arrivals:, clockwise:)
    (arrivals.excluding(arrivals.last).map(&:station).sum { |station| station.distance_to_next(clockwise:) }).round(2)
  end

  def remaining_distance(arrivals:, clockwise:)
    (Station.total_distance - arrived_distance(arrivals:, clockwise:)).round(2)
  end

  def number_of_walked(arrivals)
    arrivals_without_departure = arrivals.slice(1..-1)
    arrivals_without_departure.length
  end

  def number_of_remaining(arrivals)
    Station.count - number_of_walked(arrivals)
  end

  def deletable?(arrival, walk)
    current_user == walk.user && arrival == walk.arrivals.order(:created_at).last && arrival != walk.arrival_of_departure
  end
end

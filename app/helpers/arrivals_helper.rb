# frozen_string_literal: true

module ArrivalsHelper
  def remaining_distance(arrived_distance)
    (Station.total_distance - arrived_distance).round(2)
  end

  def number_of_remaining(number_of_walked)
    Station.total_count - number_of_walked
  end

  def deletable?(arrival, walk)
    current_user == walk.user && arrival == walk.arrivals.order(:created_at).last && arrival != walk.arrival_of_departure
  end
end

# frozen_string_literal: true

module ArrivalsHelper
  def remaining_distance(arrived_distance:)
    (Station.total_distance - arrived_distance).round(2)
  end

  def number_of_remaining(number_of_walked:)
    Station.cache_count - number_of_walked
  end

  def deletable?(editable:, arrival:, arrivals:)
    editable && arrival == arrivals.last && arrival != arrivals.first
  end
end

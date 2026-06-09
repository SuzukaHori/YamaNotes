# frozen_string_literal: true

module ArrivalsHelper
  def remaining_distance(arrived_distance:)
    (Station.total_distance - arrived_distance).round(2)
  end

  def number_of_remaining(number_of_walked:)
    Station.cache_count - number_of_walked
  end

  def deletable?(arrival:, arrivals:)
    arrival == arrivals.last && arrival != arrivals.first
  end

  def memo_with_links(memo)
    raw Rinku.auto_link(simple_format(h(memo)), :all, 'target="_blank"') # rubocop:disable Rails/OutputSafety
  end
end

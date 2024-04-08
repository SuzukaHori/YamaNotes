class Arrival < ApplicationRecord
  belongs_to :walk
  belongs_to :station
  validates :arrived_at, presence: true
  validate :prohibit_arrival_without_next_station

  def prohibit_arrival_without_next_station
    return if walk.arrivals.empty?

    is_correct_next_station =
      if walk.clockwise
        walk.current_station.clockwise_next_station == station
      else
        station == Station.find_by(clockwise_next_station: walk.current_station)
      end
    return if is_correct_next_station

    errors.add :station_id, '隣駅以外に到着することはできません'
  end
end

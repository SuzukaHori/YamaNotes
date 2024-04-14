class Arrival < ApplicationRecord
  belongs_to :walk
  belongs_to :station
  validates :arrived_at, presence: true
  validate :prohibit_arrival_without_next_station, if: -> { validation_context == :create }
  before_validation :convert_blank_to_nil
  before_destroy :check_arrival_location, unless: -> { destroyed_by_association }

  private

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

  def convert_blank_to_nil
    self.memo = nil if memo.blank?
  end

  def check_arrival_location
    return if destroyed_by_association
    return if self == walk.arrivals.order(:arrived_at).last

    errors.add :station_id, '最後の到着以外は削除できません'
    throw(:abort)
  end
end

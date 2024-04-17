class Arrival < ApplicationRecord
  belongs_to :walk
  belongs_to :station
  validates :arrived_at, presence: true
  validate :prohibit_arrival_without_next_station, if: -> { validation_context == :create }
  validate :check_arrived_time, if: -> { validation_context == :update }
  before_validation :convert_blank_to_nil
  before_destroy :check_arrival_location, unless: -> { destroyed_by_association }

  private

  def check_arrived_time
    errors.add :arrived_at, 'に未来の時刻は設定できません' if !arrived_at_earlier_than_now?
    errors.add :arrived_at, 'は一つ前の到着時刻より前、一つ後ろの到着時間より後の時刻を設定してください' if !arrived_at_within_range?
  end

  def arrived_at_earlier_than_now?
    arrived_at < Time.current
  end

  def arrived_at_within_range?
    arrivals = walk.arrivals.order(:id)
    self_index = arrivals.find_index(self)
    next_arrival_time = arrivals[self_index + 1]&.arrived_at
    prev_arrival_time = self_index.zero? ? nil : arrivals[self_index - 1].arrived_at
    (prev_arrival_time..next_arrival_time).cover? arrived_at
  end

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
    return if self == walk.sorted_arrivals.last

    errors.add :station_id, '最後の到着以外は削除できません'
    throw(:abort)
  end
end

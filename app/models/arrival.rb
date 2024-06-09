# frozen_string_literal: true

class Arrival < ApplicationRecord
  belongs_to :walk
  belongs_to :station
  before_save :convert_nil_to_blank
  validates :arrived_at, presence: true
  validates :memo, length: { maximum: 140 }, allow_blank: true
  validate :prohibit_arrival_without_next_station, on: :create
  validate :arrivals_count_must_be_within_limit, on: :create
  validate :check_arrived_time, on: :update
  before_save :truncate_seconds_of_arrived_time
  before_destroy :check_arrival_location, unless: -> { destroyed_by_association }

  private

  def check_arrived_time
    errors.add :arrived_at, 'に未来の時刻は設定できません' if arrival_time_is_later_than_current?
    errors.add :arrived_at, 'は、一つ前の到着時刻より後、一つ後ろの到着時間より前の時刻を設定してください' if arrival_time_is_outside_of_range?
  end

  def arrival_time_is_later_than_current?
    Time.current < arrived_at
  end

  def arrival_time_is_outside_of_range?
    arrivals = Arrival.where(walk:).order(:created_at)
    self_index = arrivals.find_index(self)
    next_arrival_time = self == arrivals.last ? nil : arrivals[self_index + 1].arrived_at
    prev_arrival_time = self == arrivals.first ? nil : arrivals[self_index - 1].arrived_at
    !(prev_arrival_time..next_arrival_time).cover? arrived_at
  end

  def prohibit_arrival_without_next_station
    arrival_last = Arrival.includes(:station).where(walk:).order(:created_at).last
    return unless arrival_last

    current_station = arrival_last.station
    is_correct_next_station =
      if walk.clockwise
        current_station.clockwise_next_station == station
      else
        Station.find_by(clockwise_next_station: current_station) == station
      end
    return if is_correct_next_station

    errors.add :station_id, '隣駅以外に到着することはできません'
  end

  def convert_nil_to_blank
    self.memo = '' if memo.nil?
  end

  def check_arrival_location
    return if self == walk.arrivals.order(:created_at).last

    errors.add :base, '最後の到着以外は削除できません'
    throw(:abort)
  end

  def truncate_seconds_of_arrived_time
    self.arrived_at = arrived_at.beginning_of_minute
  end

  def arrivals_count_must_be_within_limit
    errors.add(:base, '駅の数以上の到着記録は作成できません') if walk.arrivals.count > Station.count
  end
end

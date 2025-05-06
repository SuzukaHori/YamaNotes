# frozen_string_literal: true

class Walk < ApplicationRecord
  belongs_to :user
  has_many :arrivals, dependent: :destroy
  has_many :stations, through: :arrivals
  validates :clockwise, inclusion: { in: [true, false] }
  validate :active_walk_uniqueness, on: :create

  def current_station
    arrivals.includes(:station).order(:created_at).last&.station
  end

  def arrived_stations
    arrivals.order(:created_at).includes(:station).map(&:station)
  end

  def arrived_distance
    if finished?
      Station.total_distance
    else
      exclude_station_id = clockwise ? arrivals.order(:created_at).last&.station_id : arrivals.order(:created_at).first&.station_id
      distance_list = arrivals.joins(:station).where.not(station_id: exclude_station_id).pluck('stations.clockwise_distance_to_next')
      distance_list.sum.round(2)
    end
  end

  def arrival_of_departure
    arrivals.order(:created_at)&.first
  end

  def arrival_of_goal
    arrivals.order(:created_at).last if finished?
  end

  def number_of_walked
    arrivals.count - 1
  end

  def finished?
    arrivals.count > Station.cache_count
  end

  private

  def active_walk_uniqueness
    # TODO: 後ほど active な walk のみを対象に限定する
    return if user.walks.empty?

    errors.add(:user_id, '一人につき、実施中の歩行記録は一つしか作成できません')
  end
end

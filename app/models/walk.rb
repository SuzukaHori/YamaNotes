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
    arrivals.loaded? ? arrivals.min_by(&:created_at) : arrivals.order(:created_at).first
  end

  def arrival_of_goal
    return unless finished?

    arrivals.loaded? ? arrivals.max_by(&:created_at) : arrivals.order(:created_at).last
  end

  def number_of_walked
    arrivals.count - 1
  end

  def finished?
    arrivals.size > Station.cache_count
  end

  private

  def active_walk_uniqueness
    return unless user.walks.exists?(active: true)

    errors.add(:user_id, :only_one_active_walk)
  end
end

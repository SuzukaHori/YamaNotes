# frozen_string_literal: true

class Walk < ApplicationRecord
  belongs_to :user
  has_many :arrivals, dependent: :destroy
  has_many :stations, through: :arrivals
  validates :clockwise, inclusion: { in: [true, false] }
  validates :user_id, uniqueness: { message: '一人につき、歩行記録は一つしか作成できません' }

  def current_station
    arrivals.includes(:station).order(:created_at).last&.station
  end

  def arrived_stations
    arrivals.order(:created_at).includes(:station).map(&:station)
  end

  def arrived_distance
    if clockwise
      exclude_station_id = arrivals.order(:created_at).last&.station_id
    else
      exclude_station_id = arrivals.order(:created_at).first&.station_id
    end
    total_distance = arrivals.includes(:station).where.not(station_id: exclude_station_id).sum { |arrival| arrival.station.clockwise_distance_to_next }
    total_distance.round(2)
  end

  def arrival_of_departure
    arrivals.order(:created_at)&.first
  end

  def arrival_of_goal
    arrivals.order(:created_at).last if finished?
  end

  def finished?
    arrivals.count > Station.count
  end
end

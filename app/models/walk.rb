class Walk < ApplicationRecord
  belongs_to :user
  has_many :arrivals, dependent: :destroy
  has_many :stations, through: :arrivals
  validates :clockwise, inclusion: { in: [true, false] }

  def current_station
    sorted_arrivals.last.station
  end

  def arrived_stations
    arrivals.includes(:station).order(arrived_at: :asc).map(&:station)
  end

  def arrivals_without_departure
    sorted_arrivals.slice(1..-1)
  end

  def sorted_arrivals
    arrivals.includes(:station).order(arrived_at: :asc)
  end

  def latest_arrival
    sorted_arrivals.last
  end

  def total_distance_walked
    arrived_stations.sum(&:clockwise_distance_to_next) - current_station.clockwise_distance_to_next
  end

  def walked_stations_number
    arrivals_without_departure.length
  end

  def departure_station
    arrivals.order(:created_at).first.station
  end
end

class Walk < ApplicationRecord
  belongs_to :user
  has_many :arrivals, dependent: :destroy
  has_many :stations, through: :arrivals
  validates :clockwise, inclusion: { in: [true, false] }

  def current_station
    sorted_arrivals_with_stations.last.station unless arrivals.empty?
  end

  def arrived_stations
    sorted_arrivals_with_stations.map(&:station)
  end

  def sorted_arrivals_with_stations
    arrivals.includes(:station).order(:id)
  end

  def latest_arrival
    sorted_arrivals_with_stations.last
  end

  def total_distance_finished
    arrived_stations.sum(&:clockwise_distance_to_next) - current_station.clockwise_distance_to_next
  end

  def arrival_of_departure
    arrivals.order(:id).first
  end

  def goal
    arrivals.order(:id).last if finished?
  end

  def finished?
    arrivals.count > Station.count
  end
end

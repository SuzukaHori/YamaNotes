class Walk < ApplicationRecord
  belongs_to :user
  has_many :arrivals, dependent: :destroy
  has_many :stations, through: :arrivals
  validates :clockwise, inclusion: { in: [true, false] }

  def current_station
    arrivals_with_stations.last.station unless arrivals.empty?
  end

  def arrived_stations
    arrivals_with_stations.map(&:station)
  end

  def arrival_of_departure
    arrivals&.first
  end

  def arrival_of_goal
    arrivals.last if finished?
  end

  def finished?
    arrivals.count > Station.count
  end

  private

  def arrivals_with_stations
    arrivals.includes(:station)
  end
end

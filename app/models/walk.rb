class Walk < ApplicationRecord
  belongs_to :user
  has_many :arrivals, dependent: :destroy
  has_many :stations, through: :arrivals
  validates :clockwise, inclusion: { in: [true, false] }

  def current_station
    arrived.any? ? arrived.last.station : departure_station
  end

  def arrived_stations
    stations.select { |station| arrived.map(&:station_id).include?(station.id) }
  end

  def total_distance_walked
    arrived_stations.sum(&:clockwise_distance_to_next).round(2)
  end

  def through_station_ids
    [*departure_station, *arrived_stations].map(&:id)
  end

  private

  def departure_station
    arrivals.order(:created_at).first.station
  end

  def arrived
    arrivals.order(arrived_at: :asc).select(&:arrived?)
  end
end

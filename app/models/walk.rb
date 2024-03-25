class Walk < ApplicationRecord
  belongs_to :user
  has_many :arrivals, dependent: :destroy
  has_many :stations, through: :arrivals
  validates :clockwise, inclusion: { in: [true, false] }

  def arrived_stations
    arrived = self.arrivals.reject { |arrival| arrival.arrived_at.nil? }
    arrived.map { |arrived| Station.find(arrived.station_id)}
  end

  def distance_walked
    arrived_stations.sum(&:clockwise_distance_to_next)
  end
end

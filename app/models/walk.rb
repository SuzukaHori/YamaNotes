class Walk < ApplicationRecord
  belongs_to :user
  has_many :arrivals, dependent: :destroy
  has_many :stations, through: :arrivals
  validates :clockwise, inclusion: { in: [true, false] }

  def current_station
    if arrived.any?
      arrived.max_by{|arrival| arrival.arrived_at}.station
    else
      self.arrivals.first.station
    end
  end

  def arrived_stations
    arrived.map { |arrival| Station.find(arrival.station_id)}
  end

  def distance_walked
    arrived_stations.sum(&:clockwise_distance_to_next).round(2)
  end

  def next_station
    next_station_id = 
    if self.arrived == Station.all.length
      nil
    elsif current_station.id == Station.all.length
      1
    else
      current_station.id + 1
    end
    Station.find(next_station_id)
  end

  private

  def arrived
    self.arrivals.where.not(arrived_at: nil).order(arrived_at: :asc)
  end
end

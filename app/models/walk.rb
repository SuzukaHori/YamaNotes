class Walk < ApplicationRecord
  belongs_to :user
  has_many :arrivals, dependent: :destroy
  has_many :stations, through: :arrivals
  validates :clockwise, inclusion: { in: [true, false] }

  def current_station
    sorted_arrivals.any? ? sorted_arrivals.last.station : departure_station
  end

  def arrived_stations
    sorted_arrivals.map(&:station)
  end

  def arrivals_without_departure
    sorted_arrivals.slice(1..-1)
  end

  private

  def departure_station
    arrivals.order(:created_at).first.station
  end

  def sorted_arrivals
    arrivals.order(arrived_at: :asc)
  end
end

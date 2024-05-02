class Walk < ApplicationRecord
  belongs_to :user
  has_many :arrivals, dependent: :destroy
  has_many :stations, through: :arrivals
  validates :clockwise, inclusion: { in: [true, false] }

  def current_station
    arrivals.order(created_at: :desc).limit(1).includes(:station).first&.station
  end

  def arrived_stations
    arrivals.order(:created_at).includes(:station).map(&:station)
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

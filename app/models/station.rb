class Station < ApplicationRecord
  has_many :arrivals, dependent: :destroy
  has_many :walks, through: :arrivals
  has_one :station, class_name: 'Station', inverse_of: :clockwise_next_station, dependent: :destroy
  belongs_to :clockwise_next_station, class_name: 'Station', inverse_of: :station

  def next(clockwise:)
    if clockwise
      next_id = id == Station.count ? 1 : id + 1
      Station.find(next_id)
    else
      Station.find_by(clockwise_next_station: self)
    end
  end

  def self.total_distance
    Station.all.sum(&:clockwise_distance_to_next)
  end
end

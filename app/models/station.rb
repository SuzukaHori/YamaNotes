class Station < ApplicationRecord
  has_many :arrivals, dependent: :destroy
  has_many :walks, through: :arrivals

  def self.total_distance
    Station.all.sum(&:clockwise_distance_to_next)
  end
end

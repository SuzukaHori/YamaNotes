class Station < ApplicationRecord
  has_many :arrivals, dependent: :destroy
  has_many :walks, through: :arrivals

  def next
    next_id = id == Station.all.map(&:id).max ? 1 : id + 1
    Station.find(next_id)
  end

  def self.total_distance
    Station.all.sum(&:clockwise_distance_to_next)
  end
end

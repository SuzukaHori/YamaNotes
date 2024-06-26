# frozen_string_literal: true

class Station < ApplicationRecord
  has_many :arrivals, dependent: :destroy
  has_many :walks, through: :arrivals
  has_one :station, class_name: 'Station', inverse_of: :clockwise_next_station, dependent: :destroy
  belongs_to :clockwise_next_station, class_name: 'Station', inverse_of: :station
  validates :name, presence: true
  validates :longitude, presence: true, numericality: true, uniqueness: { scope: :latitude }
  validates :latitude, presence: true, numericality: true
  validates :clockwise_distance_to_next, presence: true, numericality: true

  def next(clockwise:)
    if clockwise
      next_id = id == Station.cache_count ? 1 : id + 1
      Station.find(next_id)
    else
      Station.find_by(clockwise_next_station: self)
    end
  end

  def distance_to_next(clockwise:)
    if clockwise
      clockwise_distance_to_next
    else
      self.next(clockwise:).clockwise_distance_to_next
    end
  end

  class << self
    def total_distance
      Station.cache_all.sum(&:clockwise_distance_to_next)
    end

    def cache_count
      Rails.cache.fetch('station_count', expires_in: 12.hours) do
        Station.count.to_i
      end
    end

    def cache_all
      Rails.cache.fetch('station_all', expires_in: 12.hours) do
        Station.all.to_a
      end
    end
  end
end

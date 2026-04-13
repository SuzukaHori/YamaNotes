# frozen_string_literal: true

class GpsPoint < ApplicationRecord
  belongs_to :walk
  validates :latitude, :longitude, :recorded_at, presence: true
end

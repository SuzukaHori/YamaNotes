class Arrival < ApplicationRecord
  belongs_to :walk
  belongs_to :station
  validates :arrived_at, presence: true
end

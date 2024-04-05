class Arrival < ApplicationRecord
  belongs_to :walk
  belongs_to :station
  validates :station_id, uniqueness: { scope: :walk_id }
  validates :arrived_at, presence: true

  def arrived?
    !arrived_at.nil?
  end
end

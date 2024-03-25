class Arrival < ApplicationRecord
  belongs_to :walk
  belongs_to :station
  validates :station_id, presence: true, uniqueness: {scope: :walk_id}
end

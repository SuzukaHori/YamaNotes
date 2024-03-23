class Arrival < ApplicationRecord
  belongs_to :walk
  belongs_to :station
end

class Station < ApplicationRecord
  has_many :arrivals, dependent: :destroy
  has_many :walks, through: :arrivals
end

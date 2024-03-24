class Walk < ApplicationRecord
  belongs_to :user
  has_many :arrivals, dependent: :destroy
  has_many :stations, through: :arrivals

  validates :clockwise, presence: true
end

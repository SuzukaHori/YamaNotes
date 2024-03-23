class User < ApplicationRecord
  has_one :walk, dependent: :destroy
  has_many :arrivals, through: :walk
  devise :omniauthable, omniauth_providers: %i[google_oauth2]
end

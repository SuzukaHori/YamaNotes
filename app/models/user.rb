class User < ApplicationRecord
  has_one :walk
  devise :omniauthable, omniauth_providers: %i[google_oauth2]
end

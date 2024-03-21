class User < ApplicationRecord
  devise :omniauthable, omniauth_providers: %i[google_oauth2]
end

# frozen_string_literal: true

class User < ApplicationRecord
  devise :omniauthable, :rememberable, omniauth_providers: %i[google_oauth2]
  has_many :walks, dependent: :destroy
  has_many :arrivals, through: :walks
  validates :uid, uniqueness: { scope: :provider }, presence: true
  validates :provider, inclusion: { in: ['google_oauth2'] }, presence: true
end

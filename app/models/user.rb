# frozen_string_literal: true

class User < ApplicationRecord
  devise :omniauthable, :rememberable, omniauth_providers: %i[google_oauth2]
  has_one :walk, dependent: :destroy
  has_many :arrivals, through: :walk
  validates :uid, uniqueness: { scope: :provider }, numericality: { only_integer: true }, presence: true
  validates :provider, inclusion: { in: ['google_oauth2'] }, presence: true
end

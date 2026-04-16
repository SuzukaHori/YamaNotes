# frozen_string_literal: true

class FeatureFlag < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  def self.enabled?(name)
    find_by(name: name)&.enabled? || false
  end

  def self.enable!(name)
    find_or_create_by!(name: name).update!(enabled: true)
  end

  def self.disable!(name)
    find_or_create_by!(name: name).update!(enabled: false)
  end
end

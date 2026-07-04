# frozen_string_literal: true

class Suspension < ApplicationRecord
  belongs_to :walk

  validates :started_at, presence: true
  validate :walk_must_be_in_progress, on: :create
  validate :prohibit_multiple_ongoing_suspensions, on: :create
  validate :ended_at_must_be_after_started_at, if: -> { ended_at.present? }

  scope :ongoing, -> { where(ended_at: nil) }

  def ongoing?
    ended_at.nil?
  end

  def duration_seconds
    (ended_at || Time.current) - started_at
  end

  private

  def walk_must_be_in_progress
    return if walk&.active? && !walk.finished?

    errors.add(:base, :walk_not_in_progress)
  end

  def prohibit_multiple_ongoing_suspensions
    errors.add(:base, :already_suspended) if walk&.suspensions&.ongoing&.exists?
  end

  def ended_at_must_be_after_started_at
    errors.add(:ended_at, :must_be_after_started_at) if ended_at <= started_at
  end
end

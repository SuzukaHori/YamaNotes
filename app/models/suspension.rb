# frozen_string_literal: true

class Suspension < ApplicationRecord
  belongs_to :walk

  validates :started_at, presence: true
  validates :reason, length: { maximum: 250 }, allow_blank: true
  validate :walk_must_be_in_progress, on: :create
  validate :prohibit_multiple_ongoing_suspensions, on: :create
  validate :ended_at_must_be_after_started_at, if: -> { ended_at.present? }
  validate :check_suspension_times, on: :update

  before_save :convert_nil_reason_to_blank

  scope :ongoing, -> { where(ended_at: nil) }

  def ongoing?
    ended_at.nil?
  end

  def duration_seconds
    (ended_at || Time.current) - started_at
  end

  private

  def convert_nil_reason_to_blank
    self.reason = '' if reason.nil?
  end

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

  def check_suspension_times
    return if started_at.blank?

    errors.add :base, :walk_not_in_progress if walk.finished?
    errors.add :started_at, :cannot_be_future if Time.current < started_at
    errors.add :ended_at, :cannot_be_future if ended_at.present? && Time.current < ended_at
    errors.add :started_at, :before_departure if started_at < walk.arrival_of_departure.arrived_at
    errors.add :base, :overlaps_with_another_suspension if overlaps_with_another_suspension?
  end

  def overlaps_with_another_suspension?
    walk.suspensions.where.not(id: id)
        .where('started_at < ?', ended_at || Time.current)
        .where('ended_at IS NULL OR ended_at > ?', started_at)
        .exists?
  end
end

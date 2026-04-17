# frozen_string_literal: true

class Arrival < ApplicationRecord
  belongs_to :walk
  belongs_to :station
  has_one_attached :image

  before_save :convert_nil_to_blank
  before_update :add_space_after_url

  validates :arrived_at, presence: true
  validates :memo, length: { maximum: 250 }, allow_blank: true # DBの制限は255字だが、リンクでスペースを生成する場合があるため250に設定
  validate :prohibit_arrival_without_next_station, on: :create
  validate :arrivals_count_must_be_within_limit, on: :create
  validate :check_arrived_time, on: :update
  validate :image_content_type_must_be_valid, if: -> { image.attached? }
  validate :image_size_must_be_within_limit, if: -> { image.attached? }

  before_save :truncate_seconds_of_arrived_time
  before_destroy :check_arrival_location, unless: -> { destroyed_by_association }

  private

  def check_arrived_time
    errors.add :arrived_at, :cannot_be_future if arrival_time_is_later_than_current?
    errors.add :arrived_at, :out_of_range if arrival_time_is_outside_of_range?
  end

  def arrival_time_is_later_than_current?
    Time.current < arrived_at
  end

  def arrival_time_is_outside_of_range?
    arrivals = Arrival.where(walk:).order(:created_at)
    self_index = arrivals.find_index(self)
    next_arrival_time = self == arrivals.last ? nil : arrivals[self_index + 1].arrived_at
    prev_arrival_time = self == arrivals.first ? nil : arrivals[self_index - 1].arrived_at
    !(prev_arrival_time..next_arrival_time).cover? arrived_at
  end

  def prohibit_arrival_without_next_station
    arrival_last = Arrival.includes(:station).where(walk:).order(:created_at).last
    return unless arrival_last

    current_station = arrival_last.station
    is_correct_next_station =
      if walk.clockwise
        current_station.clockwise_next_station == station
      else
        Station.find_by(clockwise_next_station: current_station) == station
      end
    return if is_correct_next_station

    errors.add :station_id, :must_be_adjacent_station
  end

  def convert_nil_to_blank
    self.memo = '' if memo.nil?
  end

  def add_space_after_url
    urls = URI.extract(memo)
    return if urls.empty?

    urls.each do |url|
      memo.gsub!(/#{url}(?!\s)/, "#{url} ") # rinku gemでURLの切れ目が正しく判定できない場合があるため、空白を追加
    end
  end

  def check_arrival_location
    return if self == walk.arrivals.order(:created_at).last

    errors.add :base, :only_last_arrival_can_be_deleted
    throw(:abort)
  end

  def truncate_seconds_of_arrived_time
    self.arrived_at = arrived_at.beginning_of_minute
  end

  def arrivals_count_must_be_within_limit
    errors.add(:base, :arrivals_limit_exceeded) if walk.arrivals.count > Station.cache_count
  end

  def image_content_type_must_be_valid
    return if %w[image/png image/jpeg].include?(image.content_type)

    errors.add(:image, :invalid_content_type)
  end

  def image_size_must_be_within_limit
    return if image.byte_size <= 5.megabytes

    errors.add(:image, :too_large)
  end
end

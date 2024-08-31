# frozen_string_literal: true

module StationHelper
  def station_image_path(station:)
    regex_for_file_name = /\A#{station.id}_.+\.png\z/
    images = Dir.entries(Rails.root.join('app/assets/images/arrivals'))
    filename = images.find { |name| name.match?(regex_for_file_name) } || 'default.png'

    "arrivals/#{filename}"
  end
end

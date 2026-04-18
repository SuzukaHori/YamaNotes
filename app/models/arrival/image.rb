# frozen_string_literal: true

module Arrival::Image
  extend ActiveSupport::Concern

  MAX_WIDTH        = 400
  MAX_HEIGHT       = 400
  ACCEPTED_FORMATS = %w[image/png image/jpeg].freeze
  WEBP_CONTENT_TYPE = "image/webp"

  included do
    has_one_attached :image do |attachable|
      attachable.variant :display, resize_to_limit: [MAX_WIDTH, MAX_HEIGHT]
    end

    validate :image_content_type_must_be_valid, if: -> { image.attached? }
    validate :image_size_must_be_within_limit,  if: -> { image.attached? }
  end

  def attach_image(uploaded_file)
    image.attach(resize_image(uploaded_file))
  end

  private

  def resize_image(uploaded_file)
    return uploaded_file unless ACCEPTED_FORMATS.include?(uploaded_file.content_type)

    output = ImageProcessing::Vips
               .source(uploaded_file.path)
               .convert("webp")
               .resize_to_limit(MAX_WIDTH, MAX_HEIGHT)
               .call
    filename = "#{File.basename(uploaded_file.original_filename, ".*")}.webp"
    { io: output, filename:, content_type: WEBP_CONTENT_TYPE }
  end

  def image_content_type_must_be_valid
    return if ACCEPTED_FORMATS.include?(image.content_type) || image.content_type == WEBP_CONTENT_TYPE

    errors.add(:image, :invalid_content_type)
  end

  def image_size_must_be_within_limit
    return if image.byte_size <= 5.megabytes

    errors.add(:image, :too_large)
  end
end

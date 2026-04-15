# frozen_string_literal: true

class Arrivals::ImagesController < ApplicationController
  before_action :set_arrival

  def create
    resized_image = ImageProcessing::Vips
      .source(params[:image])
      .resize_to_fit(800, 800)
      .call

    blob = ActiveStorage::Blob.create_and_upload!(
      io: resized_image,
      filename: params[:image].original_filename,
      content_type: params[:image].content_type
    )
    @arrival.image.attachment&.purge
    ActiveStorage::Attachment.create!(
      name: 'image',
      record: @arrival,
      blob:
    )
    redirect_to arrivals_path
  end

  def destroy
    @arrival.image.purge
    redirect_to arrivals_path
  end

  private

  def set_arrival
    @arrival = current_user.arrivals.find(params[:arrival_id])
  end
end

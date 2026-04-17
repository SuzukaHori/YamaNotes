# frozen_string_literal: true

class Arrivals::ImagesController < ApplicationController
  before_action :set_arrival

  def create
    @arrival.image.attach(params[:image])
    if @arrival.valid? && @arrival.image.persisted?
      redirect_to arrivals_path, notice: t('.attached')
    else
      @arrival.image.purge if @arrival.image.attached?
      redirect_to arrivals_path, alert: @arrival.errors.full_messages_for(:image).to_sentence
    end
  end

  private

  def set_arrival
    @arrival = current_user.arrivals.find(params[:arrival_id])
  end
end

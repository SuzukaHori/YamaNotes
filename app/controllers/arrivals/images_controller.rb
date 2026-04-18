# frozen_string_literal: true

class Arrivals::ImagesController < ApplicationController
  before_action :set_arrival

  def create
    if @arrival.image.attach(params[:image])
      redirect_to arrivals_path, notice: t('.attached')
    else
      @arrival.image.purge
      redirect_to arrivals_path, alert: @arrival.errors.full_messages.to_sentence
    end
  end

  def destroy
    @arrival.image.purge
    redirect_to arrivals_path, notice: t('.purged')
  end

  private

  def set_arrival
    @arrival = current_user.arrivals.find(params[:arrival_id])
  end
end

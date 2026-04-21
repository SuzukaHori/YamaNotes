# frozen_string_literal: true

class Arrivals::ImagesController < ApplicationController
  before_action :set_arrival

  def destroy
    @arrival.image.purge
    redirect_to arrivals_path, notice: t('.purged')
  end

  private

  def set_arrival
    @arrival = current_user.arrivals.find(params[:arrival_id])
  end
end

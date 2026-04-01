# frozen_string_literal: true

class Walk::ArrivalsController < ApplicationController
  before_action :set_walk, only: %i[index]

  def index
    @arrivals = @walk.arrivals.order(:created_at).includes(:station)
  end

  private

  def set_walk
    @walk = current_user.walks.find(params[:walk_id])
  end
end

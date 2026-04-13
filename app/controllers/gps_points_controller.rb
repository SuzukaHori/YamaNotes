# frozen_string_literal: true

class GpsPointsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_walk

  def create
    gps_point = @walk.gps_points.build(gps_point_params)
    if gps_point.save
      head :created
    else
      head :unprocessable_entity
    end
  end

  private

  def set_walk
    @walk = current_user.walks.find(params[:walk_id])
  rescue ActiveRecord::RecordNotFound
    head :not_found
  end

  def gps_point_params
    params.require(:gps_point).permit(:latitude, :longitude, :recorded_at)
  end
end

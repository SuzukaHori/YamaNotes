# frozen_string_literal: true

class Walks::ArrivalsController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :set_walk, only: %i[index]

  def index
    if @walk.publish
      @arrivals = @walk.arrivals.order(:created_at).includes(:station)
      @user = current_user
      render 'arrivals/index'
    else
      redirect_to root_path, notice: 'この到着記録は非公開です'
    end
  end

  private

  def set_walk
    @walk = Walk.find(params[:walk_id])

    return if @walk

    redirect_to root_path, alert: '歩行記録が存在しません。'
  end
end

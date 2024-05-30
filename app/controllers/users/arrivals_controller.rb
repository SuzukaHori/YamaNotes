# frozen_string_literal: true

class Users::ArrivalsController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :set_walk, only: %i[index]

  def index
    if @walk.publish || current_user == @walk.user
      @arrivals = @walk.arrivals.order(:created_at).includes(:station)
      render 'arrivals/index'
    else
      redirect_to root_path, notice: 'この到着記録は非公開です'
    end
  end

  private

  def set_walk
    user = User.find(params[:user_id])
    @walk = user.walk
  end
end

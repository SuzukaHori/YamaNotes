class Users::ArrivalsController < ApplicationController
  before_action :set_walk, only: %i[index]
  skip_before_action :authenticate_user!

  def index
    if @walk.publish || current_user == @walk.user
      @arrivals = @walk.arrivals.includes(:station)
      render 'arrivals/index'
    else
      redirect_to root_path, notice: 'この到着記録は非公開です'
    end
  end

  def set_walk
    user = User.find(params[:id])
    @walk = user.walk
  end
end

class Users::ArrivalsController < ApplicationController
  def index
    user = User.find(params[:id])
    walk = user.walk
    if walk.publish || current_user == user
      @walk = user.walk
      @arrivals = @walk.arrivals.includes(:station)
      render 'arrivals/index'
    else
      redirect_to root_path, notice: 'この到着記録は非公開です'
    end
  end
end

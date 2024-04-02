class WalksController < ApplicationController
  def show
    @walk = current_user.walk
    @arrival = Arrival.new
  end

  def new
    @walk = Walk.new
  end

  def create
    if current_user.walk.present?
      redirect_to walk_url, alert: '歩行記録は一つしか作成できません'
      return
    end
    walk = current_user.build_walk(clockwise: params[:clockwise])
    arrival = walk.arrivals.new(station_id: params[:station_id])
    if walk.save && arrival.save
      redirect_to walk_url, notice: '歩行記録の作成に成功しました'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update; end

  def delete; end

  private

  def walk_params
    params.require(:walk).permit(:user_id, :clockwise)
  end
end

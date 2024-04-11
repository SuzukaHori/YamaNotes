class WalksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_walk, only: [:show, :update]

  def show
    @arrival = Arrival.new
  end

  def new
    @walk = Walk.new
    @arrival = Arrival.new
  end

  def create
    if current_user.walk.present?
      redirect_to walk_url, alert: '歩行記録は一つしか作成できません'
      return
    end
    @walk = current_user.build_walk(clockwise: params[:clockwise])
    if @walk.save && @walk.arrivals.create(station_id: params[:station_id], arrived_at: Time.current)
      redirect_to walk_url, notice: '歩行記録の作成に成功しました'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @walk.update(walk_params)
      redirect_to request.referer, notice: @walk.publish ? '公開しました' : '非公開にしました'
    else
      render 'arrival/index', status: :unprocessable_entity
    end
  end

  def delete; end

  private

  def walk_params
    params.require(:walk).permit(:user_id, :clockwise, :publish)
  end

  def set_walk
    @walk = current_walk
  end
end

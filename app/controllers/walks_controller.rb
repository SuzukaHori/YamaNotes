class WalksController < ApplicationController
  before_action :set_walk, only: %i[show destroy]
  before_action :set_maptiler_key, only: %i[show]

  def show
    @arrival = Arrival.new
  end

  def new
    @walk = Walk.new
    @arrival = @walk.arrivals.new
  end

  def create
    if current_user.walk.present?
      redirect_to walk_url, alert: '歩行記録は一つしか作成できません'
      return
    end
    ActiveRecord::Base.transaction do
      walk = current_user.create_walk!(walk_params)
      walk.arrivals.create!(arrival_params)
    end
    redirect_to walk_url, notice: '歩行記録の作成に成功しました'
  end

  def update
    return unless current_walk.update(walk_params)

    redirect_to arrivals_path, notice: current_walk.publish ? '到着履歴を公開しました' : '到着履歴を非公開にしました'
  end

  def destroy
    @walk.destroy!
    redirect_to root_path, notice: '一周をリタイアしました'
  end

  private

  def walk_params
    params.require(:walk).permit(:clockwise, :publish)
  end

  def arrival_params
    params.require(:arrival).permit(:station_id, :arrived_at, :memo)
  end

  def set_walk
    @walk = current_walk
  end

  def set_maptiler_key
    gon.maptiler_key = ENV.fetch('MAPTAILER_KEY', nil)
  end
end

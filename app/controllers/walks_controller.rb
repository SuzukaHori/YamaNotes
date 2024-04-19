class WalksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_walk, only: [:show]

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
      walk = current_user.build_walk(clockwise: walk_params[:clockwise])
      walk.save!
      walk.arrivals.create!(station_id: arrival_params[:station_id], arrived_at: arrival_params[:arrived_at])
    end
    redirect_to walk_url, notice: '歩行記録の作成に成功しました'
  end

  def update
    if current_walk.update(walk_params)
      redirect_to arrivals_path, notice: walk.publish ? '到着履歴を公開しました' : '到着履歴を非公開にしました'
    else
      render 'arrival/index', status: :unprocessable_entity
    end
  end

  def destroy; end

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
end

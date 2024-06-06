# frozen_string_literal: true

class WalksController < ApplicationController
  before_action :set_walk, only: %i[show destroy]
  before_action :set_maptiler_key, only: %i[show]
  before_action :redirect_if_walk_not_exist, only: %i[show]

  def show
    @arrival = Arrival.new
    @arrivals = @walk.arrivals.order(:created_at).includes(:station)
    @station = @walk.current_station
  end

  def new
    @walk = Walk.new
    @arrival = @walk.arrivals.new
  end

  def create
    walk = Walk.new(**walk_params, user: current_user)
    if walk.invalid?
      redirect_to walk_url(walk), alert: walk.errors.full_messages.join
      return
    end
    walk.transaction do
      walk.save!
      walk.arrivals.create!(**arrival_params, arrived_at: Time.current)
    end
    redirect_to walk_url(@walk), notice: '歩行記録ノートを作成しました。'
  end

  def update
    return unless current_walk.update(walk_params)

    redirect_to arrivals_path, notice: current_walk.publish ? '到着履歴を公開しました。URLで到着履歴を共有しましょう。' : '到着履歴を非公開にしました。'
  end

  def destroy
    @walk.destroy!
    redirect_to root_path, notice: '歩行記録ノートを削除しました。'
  end

  private

  def redirect_if_walk_not_exist
    return unless current_walk.nil?

    redirect_to new_walk_path
  end

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

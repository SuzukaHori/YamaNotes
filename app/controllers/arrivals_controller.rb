# frozen_string_literal: true

class ArrivalsController < ApplicationController
  before_action :set_arrival, only: %i[show edit update destroy]
  before_action :set_walk, only: %i[index show]
  before_action :set_user, only: %i[index]

  def index
    @arrivals = current_walk.arrivals.order(:created_at).includes(:station)
  end

  def show
    @station = @arrival.station
    @arrived_distance = @walk.arrived_distance
    @number_of_walked = @walk.number_of_walked
  end

  def edit; end

  def create
    @arrival = current_walk.arrivals.new(**arrival_params, arrived_at: Time.current)
    if @arrival.save
      redirect_to @arrival
    else
      redirect_to walk_path, alert: '到着記録を保存できませんでした。'
    end
  end

  def update
    @arrival.assign_attributes(arrival_params)
    return unless @arrival.changed?

    if @arrival.save
      flash.now.notice = '到着記録を更新しました。'
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    redirect_to arrivals_path, notice: '到着記録を削除しました。' if @arrival.destroy
  end

  private

  def set_arrival
    @arrival = current_user.arrivals.find(params[:id])
  end

  def set_user
    @user = current_user
  end

  def set_walk
    @walk = current_walk
  end

  def arrival_params
    params.require(:arrival).permit(:station_id, :arrived_at, :memo)
  end
end

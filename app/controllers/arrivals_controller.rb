# frozen_string_literal: true

class ArrivalsController < ApplicationController
  before_action :set_arrival, only: %i[show edit update destroy]
  before_action :set_walk, only: %i[index show update]
  before_action :set_arrivals, only: %i[index update]

  def index
    @user = current_user
  end

  def show
    @station = @arrival.station
    @arrived_distance = @walk.arrived_distance
    @number_of_walked = @walk.arrivals.count - 1
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
    return unless @arrival.updated?

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
    @arrival = Arrival.find(params[:id])
  end

  def set_arrivals
    @arrivals = current_walk.arrivals.order(:created_at).includes(:station)
  end

  def set_walk
    @walk = current_walk
  end

  def arrival_params
    params.require(:arrival).permit(:station_id, :arrived_at, :memo)
  end
end

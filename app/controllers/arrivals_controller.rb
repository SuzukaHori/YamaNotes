class ArrivalsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_arrival, only: %i[show edit update destroy]
  before_action :set_arrivals, only: %i[index update]
  before_action :set_walk, only: %i[index show create update]

  def index; end

  def show; end

  def edit; end

  def create
    @arrival = current_walk.arrivals.new(station_id: params[:station_id],
                                         arrived_at: Time.current.beginning_of_minute)
    if @arrival.save
      redirect_to @arrival
    else
      render 'walks/show', status: :unprocessable_entity
    end
  end

  def update
    if @arrival.update(arrival_params)
      flash.now.notice = '到着記録を更新しました'
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    if @arrival.destroy
      redirect_to arrivals_path, notice: '到着記録を削除しました'
    else
      render :index, status: :unprocessable_entity
    end
  end

  private

  def set_arrival
    @arrival = Arrival.find(params[:id])
  end

  def set_arrivals
    @arrivals = current_walk.sorted_arrivals_with_stations
  end

  def set_walk
    @walk = current_walk
  end

  def arrival_params
    params.require(:arrival).permit(:station_id, :arrived_at, :memo)
  end
end

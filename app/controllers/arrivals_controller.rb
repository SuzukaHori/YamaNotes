class ArrivalsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_arrival, only: %i[show edit update destroy]

  def index; end

  def show
    @walk = current_walk
  end

  def edit; end

  def create
    @walk = current_walk
    @arrival = current_walk.arrivals.new(station_id: params[:station_id], arrived_at: Time.current)
    if @arrival.save
      redirect_to @arrival
    else
      render 'walks/show', status: :unprocessable_entity
    end
  end

  def update; end

  def destroy; end

  private

  def set_arrival
    @arrival = Arrival.find(params[:id])
  end

  def arrival_params
    params.require(:arrival).permit(:station_id, :arrived_at)
  end
end

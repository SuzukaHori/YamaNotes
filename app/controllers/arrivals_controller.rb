class ArrivalsController < ApplicationController
  before_action :set_arrival, only: %i[show edit update destroy]

  def index; end

  def show
    @walk = current_walk
  end

  def edit; end

  def create
    @arrival = current_walk.arrivals.new(station_id: params[:station_id], arrived_at: Time.current)
    if @arrival.valid? && @arrival.save!
      flash[:notice] = 'Sucess'
      redirect_to arrival_path(@arrival.id)
    else
      flash[:alert] = @arrival.errors.full_messages.join
      redirect_to walk_url
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

class ArrivalsController < ApplicationController
  before_action :set_arrival, only: %i[show edit update destroy]

  def index; end

  def show
    @walk = current_user.walk
  end

  def edit; end

  def create
    arrivals = current_user.walk.arrivals
    if arrivals.find_by(station_id: params[:station_id]) && arrivals.find_by(station_id: params[:station_id]).arrived_at.nil?
      @arrival = arrivals.find_by(station_id: params[:station_id])
      @arrival.arrived_at = Time.current
    else
      @arrival = arrivals.new(station_id: params[:station_id], arrived_at: Time.current)
    end
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
